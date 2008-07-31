# Include hook code here

require 'ae_users'

ActiveRecord::Base.send(:include, AeUsers::Acts::Permissioned)
ActionController::Base.send(:include, AeUsers::ControllerExtensions::RequirePermission)
ActionView::Base.send(:include, AeUsers::HelperFunctions)

Inflector.inflections do |inflect|
  inflect.irregular "PermissionCache", "PermissionCaches"
end