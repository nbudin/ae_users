class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  
  include Xebec::ControllerSupport
  helper Xebec::NavBarHelper

  nav_bar :application do |nb|
    if current_person
      nb.nav_item current_person.name, profile_path
      if current_person.has_role?(:admin)
        nb.nav_item :admin_people
      end
      nb.nav_item "Log out", destroy_person_session_path
    else
      nb.nav_item "Log in", new_person_session_path
    end
  end
  
  before_filter :authenticate_person!
  
  rescue_from Acl9::AccessDenied do
    if current_person
      render 'shared/access_denied'
    else
      redirect_to new_person_session_path
    end
  end
end
