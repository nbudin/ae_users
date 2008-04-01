# AeUsers
require 'active_record'

module AeUsers
  begin
    @@db_name = Rails::Configuration.new.database_configuration["users"]["database"]
    def self.db_name
      @@db_name
    end
  rescue
  end
  
  @@signup_allowed = true
  def self.signup_allowed?
    @@signup_allowed
  end

  def self.disallow_signup
    @@signup_allowed = false
  end
  
  @@permissioned_classes = []
  def self.add_permissioned_class(klass)
    if not @@permissioned_classes.include?(klass.name)
      @@permissioned_classes.push(klass.name)
    end
  end
  
  def self.permissioned_classes
    return @@permissioned_classes.collect do |name|
      eval(name)
    end
  end
  
  def self.permissioned_class(name)
    if @@permissioned_classes.include?(name)
      return eval(name)
    end
  end

  # yeah, the following 2 functions are Incredibly Evil(tm).  I couldn't find any other way
  # to pass around an ActiveRecord class without having it be potentially overwritten on
  # association access.
  def self.profile_class
    nil
  end

  def self.profile_class=(klass)
    module_eval <<-END_FUNC
      def self.profile_class
        return #{klass.name}
      end
    END_FUNC
  end

  def self.map_openid(map)
    map.open_id_complete 'auth', :controller => "auth", :action => "login", :requirements => { :method => :get }
  end
  
  module Acts
    module Permissioned
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_permissioned(options = {})
          has_many :permissions, :as => :permissioned, :dependent => :destroy

          cattr_accessor :permission_names
          self.permission_names = options[:permission_names] || []
          self.permission_names = self.permission_names.collect do |perm|
            perm.to_s
          end
          if not self.permission_names.include? "change_permissions"
            self.permission_names.push "change_permissions"
          end

          self.permission_names.each do |perm|
            define_method("permit_#{perm}?") do |person|
              self.permitted?(person, perm)
            end
          end
          
          AeUsers.add_permissioned_class(self)

          extend AeUsers::Acts::Permissioned::SingletonMethods
          include AeUsers::Acts::Permissioned::InstanceMethods
        end
      end

      module SingletonMethods
      end

      module InstanceMethods
        def permitted?(person, permission=nil)
          person.permitted? self, permission
        end
        
        def permitted_people(permission)
          grants = permissions.find_all_by_permission(permission)
          people = []
          grants.collect {|grant| grant.grantee}.each do |grantee|
            if grantee.kind_of? Person
              if not people.include? grantee
                people << grantee
              end
            elsif grantee.kind_of? Role
              grantee.people.each do |person|
                if not people.include? person
                  people << person
                end
              end
            end
          end
          return people
        end

        def grant(grantees, permissions=nil)
          if not grantees.kind_of?(Array)
            grantees = [grantees]
          end

          if not permissions.kind_of?(Array)
            if permissions.nil?
              permissions = self.class.permission_names
            else
              permissions = [permissions]
            end
          end

          grantees.each do |grantee|
            if grantee.kind_of? Role
              permissions.each do |perm|
                Permission.create :role => grantee, :permission => perm, :permissioned => self
              end
            elsif grantee.kind_of? Person
              permissions.each do |perm|
                Permission.create :person => grantee, :permission => perm, :permissioned => self
              end
            end
          end
        end

        def revoke(grantees, permissions=nil)
          if not grantees.kind_of?(Array)
            grantees = [grantees]
          end

          if not permissions.kind_of?(Array)
            if permissions.nil?
              permissions = self.class.permission_names
            else
              permissions = [permissions]
            end
          end

          grantees.each do |grantee|
            permissions.each do |perm|
              existing = if grantee.kind_of? Role
                Permission.find_by_role_and_permission_type(grantee, perm)
              elsif grantee.kind_of? Person
                Permission.find_by_person_and_permission_type(person, perm)
              end

              if existing
                existing.destroy
              end
            end
          end
        end
      end
    end
  end

  module ControllerExtensions
    module RequirePermission
      def self.included(base)
        base.extend ClassMethods
      end

      def access_denied(msg=nil, options={})
        options = {
          :layout => active_layout
        }.update(options)
        msg ||= "Sorry, you don't have access to view that page."
        if logged_in?
          body = "If you feel you've been denied access in error, please contact the administrator of this web site."
        else
          body = "Try logging into an account."
        end
        @login = Login.new(:email => cookies['email'])
        render options.update({:inline => "<h1>#{msg}</h1>\n\n<div id=\"login\"><p><b>#{body}</b></p><%= render :partial => 'auth/auth_form' %></div>"})
      end
      
      def logged_in?
        if session[:person]
          begin
            return Person.find(session[:person])
          rescue ActiveRecord::RecordNotFound
            return nil
          end
        elsif session[:account]
          begin
            acct = Account.find(session[:account])
            session[:person] = acct.person.id
            return acct.person
          rescue ActiveRecord::RecordNotFound
            return nil
          end
        else
          return nil
        end
      end
    
      def logged_in_person
        return logged_in?
      end

      module ClassMethods
        def require_login(conditions = {})
          before_filter conditions do |controller|
            if not controller.logged_in?
              controller.access_denied "Sorry, but you need to be logged in to view that page."
            end
          end
        end

        def require_class_permission(perm_name, conditions = {})
          if conditions[:class_name]
            cn = conditions[:class_name]
          elsif conditions[:class_param]
            cpn = conditions[:class_param]
          end
          before_filter conditions do |controller|
            if cn.nil? and cpn
              cn = controller.params[cpn]
            end
            cn ||= controller.class.name.gsub(/Controller$/, "").singularize
            full_perm_name = "#{perm_name}_#{cn.tableize}"
            p = controller.logged_in_person
            if p
              logger.debug("Checking #{perm_name} permission on #{cn.pluralize} for user #{p.name}")
            end
            if not (p and p.permitted?(p, full_perm_name))
              controller.access_denied "Sorry, but you are not permitted to #{perm_name} #{cn.downcase.pluralize}."
            end
          end
        end

        def require_permission(perm_name, conditions = {})
          if conditions[:class_name]
            cn = conditions[:class_name]
          end
          id_param = conditions[:id_param] || :id
          before_filter conditions do |controller|
            cn ||= controller.class.name.gsub(/Controller$/, "").singularize
            o = eval(cn).find(controller.params[id_param])
            if not o.nil?
              p = controller.logged_in_person
              if p
                logger.debug("Checking #{perm_name} permission on #{o.class.name} #{o.id} for user #{p.name}")
              end
              if not (p and o.permitted?(p, perm_name))
                controller.access_denied "Sorry, but you are not permitted to #{perm_name} this #{cn.downcase}."
              end
            end
          end
        end

        def rest_edit_permissions(options = {})
          options = {
            :restrict_create => false,
          }.update(options)
          restrict_create = options[:restrict_create]
          options.delete(:restrict_create)
          require_permission("edit", { :only => [:edit, :update] }.update(options))
          if restrict_create
            require_class_permission("create", { :only => [:new, :create] }.update(options))
          end
          require_permission("destroy", { :only => [:destroy] }.update(options))
        end

        def rest_view_permissions(options = {})
          options = {
            :restrict_list => false,
          }.update(options)
          restrict_list = options[:restrict_list]
          options.delete(:restrict_list)
          if restrict_list
            require_class_permission("list", { :only => [:index] }.update(options))
          end
          require_permission("show", { :only => [:show] }.update(options))
        end

        def rest_permissions(options = {})
          rest_view_permissions(options)
          rest_edit_permissions(options)
        end
      end
    end
  end

  module HelperFunctions
    def permission_names(item)
      if item.kind_of? ActiveRecord::Base
        return item.class.permission_names
      else
        return item.permission_names
      end
    end
    
    def full_permission_name(item, perm)
      if item.kind_of? ActiveRecord::Base
        return perm
      else
        return "#{perm}_#{item.class.name.tableize}"
      end
    end
    
    def permission_grants(item, perm)
      if item.kind_of? ActiveRecord::Base
        grants = item.permissions.find_all_by_permission(perm)
      else
        full_perm_name = full_permission_name(item, perm)
        grants = Permission.find(:all, :conditions => ["permission = ?", full_perm_name])
      end
      return grants
    end
    
    def all_permitted?(item, perm)
      sql = "permission = ? and (role_id = 0 or role_id is null) and (person_id = 0 or person_id is null)"
      return Permission.find(:all, :conditions => [sql, full_permission_name(item, perm)]).length > 0
    end
    
    def logged_in?
      return controller.logged_in?
    end
    
    def logged_in_person
      return controller.logged_in_person
    end
    
    def app_profile(person = nil)
      if person.nil?
        person = logged_in_person
      end

      AeUsers.profile_class.find_by_person_id(person.id)
    end
    
    def user_picker(domid, options = {})
      options = {
        :people => true,
        :roles => false,
        :callback => ""
      }.update(options)
      
      render :inline => <<-ENDRHTML
<%= text_field_tag "#{domid}", "", { :style => "width: 15em; display: inline; float: none;" } %>
<div id="#{domid}_auto_complete" class="auto_complete"></div>
<%= auto_complete_field('#{domid}', :select => "grantee_id", :param_name => "permission[grantee]",
    :after_update_element => "function (el, selected) { 
        kid = el.value.split(':');
        klass = kid[0];
        id = kid[1];
        cb = function(klass, id) {
          #{options[:callback]}
        };
        cb(klass, id);
        $('#{domid}').value = '';
      }",
    :url => { :controller => "permission", :action => "auto_complete_for_permission_grantee",
      :people => #{options[:people]}, :roles => #{options[:roles]}, :escape => false}) %>
      ENDRHTML
    end
  end
end
