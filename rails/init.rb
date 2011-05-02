# Include hook code here

require 'ae_users'

ActiveRecord::Base.send(:include, AeUsers::Acts::Permissioned)
ActionController::Base.send(:include, AeUsers::ControllerExtensions::RequirePermission)
ActionView::Base.send(:include, AeUsers::HelperFunctions)
ActionView::Base.send(:include, PermissionHelper)

infl = begin
  Inflector
rescue
  ActiveSupport::Inflector
end

infl.inflections do |inflect|
  inflect.irregular "PermissionCache", "PermissionCaches"
end
