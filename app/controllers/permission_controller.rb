class PermissionController < ApplicationController
  unloadable
  require_login
  
  def admin
    @pclasses = logged_in_person.administrator_classes
    @roles = Role.find :all
  end
  
  require_class_permission "change_permissions", :class_param => "klass", :only => [:edit]
  def edit
    pclass = nil
    AeUsers.permissioned_classes.each do |pc|
      if pc.name == params[:klass]
        pclass = pc
        break
      end
    end
    
    if pclass.nil?
      render :inline => "<h1>Invalid class name <%= h AeUsers.permissioned_classes %></h1>"
    else
      if params[:id]
        @item = pclass.find(params[:id])
      else
        @item = pclass
      end
    end    
  end
  
  def auto_complete_for_permission_grantee
    raw_query = params[:q] || params[:term]
    if raw_query
      query = raw_query.strip.downcase
      liketerm = "%#{query}%"
      terms = query.split
      
      if params[:people] == "true"
        sql = terms.collect do |t|
          "((LOWER(firstname) like ?) OR (LOWER(lastname) like ?))"
        end.join(" AND ")
        doubleterms = []
        terms.each do |t|
          doubleterms.push("%#{t}%")
          doubleterms.push("%#{t}%")
        end
        @grantees = Person.find(:all, :conditions => ([sql] + doubleterms))
        @grantees += EmailAddress.find(:all,
                                       :conditions => ["LOWER(address) like ?", liketerm]).collect do |ea|
          ea.person
        end
      else
        @grantees = []
      end

      if params[:roles] == "true"      
        @grantees += Role.find(:all,
                               :conditions => ["LOWER(name) like ?", liketerm])
      end
      
      @grantees.uniq!
      @grantees.compact!
    else
      @grantees = []
    end
    
    render :partial => "add_grantee"
  end
  
  before_filter :check_grant_perms, :only => [:grant]
  layout nil, :only => [:grant]
  def grant
    perm_params = {}
    if params[:klass] == 'Person'
      @grantee = Person.find(params[:id])
      perm_params[:person_id] = @grantee.id
    else
      @grantee = Role.find(params[:id])
      perm_params[:role_id] = @grantee.id
    end
       
    @perm = Permission.create(perm_params.update(:permission => params[:perm], :permissioned => @permissioned))
    @perm.destroy_caches
  end
  
  before_filter :check_revoke_perms, :only => [:revoke]
  def revoke
    @perm.destroy_caches
    @perm.destroy
    render :nothing => true
  end
  
  def create_role
    @role = Role.create(params[:role])
    @role.grant(logged_in_person)
    redirect_to :action => 'edit_role', :id => @role.id
  end
  
  before_filter :check_edit_role_perms, :only => [:edit_role, :delete_role]
  before_filter :check_edit_role_member_perms, :only => [:add_role_member, :remove_role_member]
  def edit_role
  end
  
  def add_role_member
    @person = Person.find(params[:id])
    
    @role.people.push @person
    @role.save
    if AeUsers.cache_permissions?
      AeUsers.permission_cache.invalidate_all(@person)
    end
    
    render :partial => "role_member", :locals => {:person => @person}
  end
  
  def remove_role_member   
    @role.people.delete(@role.people.find(params[:id]))
    @role.save
    if AeUsers.cache_permissions?
      AeUsers.permission_cache.invalidate_all(@person)
    end
    
    render :nothing => true
  end
  
  def delete_role
    if AeUsers.cache_permissions?
      @role.people.each do |person|
        AeUsers.permission_cache.invalidate_all(person)
      end
    end
    @role.destroy
    render :nothing => true
  end
  
  private
  def check_grant_perms
    @permissioned = nil
    if params[:item_klass] != 'Class'
      pc = AeUsers.permissioned_class(params[:item_klass])
      @permissioned = pc.find(params[:item_id])
    end
    check_metaperms
  end
  
  def check_revoke_perms
    @perm = Permission.find(params[:id])
    @permissioned = @perm.permissioned
    check_metaperms
    if @person == @perm.grantee and @perm.permission == "change_permissions"
      access_denied "Sorry, you can't revoke your own right to change permissions.  (You'd probably regret it anyway!)" +
                    " If you're trying to transfer ownership to someone else, just give them all the permissions, and have them revoke yours."
    end
  end
  
  def check_metaperms
    @person = logged_in_person
    if not @person.permitted?(@permissioned, "change_permissions")
      access_denied "Sorry, you are not allowed to change the permissions of that object."
    end
  end
  
  def check_edit_role_perms
    @role ||= Role.find(params[:id])
    if not @role.permitted?(logged_in_person, "edit")
      access_denied "Sorry, you are not allowed to edit this role."
    end
  end
  
  def check_edit_role_member_perms
    @role = Role.find(params[:role])
    check_edit_role_perms
  end
end
