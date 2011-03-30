module PermissionHelper
  def grant_url(item, perm)
    url_for(:controller => 'permission', :action => 'grant', :perm => full_permission_name(item, perm), 
            :item_klass => item.class.name, :item_id => item.id, :escape => false)
  end

  def prototype_grant_callback(item, perm)
    return <<-EOF
    nobody = $('#{perm}_nobody');
    if (nobody) {
      nobody.remove();
    }
    new Ajax.Updater('#{perm}_insert_grants_here', '#{grant_url(item, perm)}',
          {
            parameters: { 'klass': klass, 'id': id },
            insertion: Insertion.Bottom,
          }
        );
    EOF
  end
  
  def jquery_grant_callback(item, perm)
    return <<-EOF
    $('##{perm}_nobody').remove();
    $.get('#{grant_url(item, perm)}',
      { 'klass': klass, 'id': id },
      function(data) {
        $('##{perm}_insert_grants_here').append(data);
      }
    );
    EOF
  end
  
  def grant_permission_user_picker(item, perm)
    callback = case AeUsers.js_framework
    when "prototype"
      prototype_grant_callback(item, perm)
    when "jquery"
      jquery_grant_callback(item, perm)
    end
    
    user_picker "#{perm}_grantee", :roles => true, :callback => callback
  end
end
