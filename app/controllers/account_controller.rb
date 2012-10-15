class AccountController < ApplicationController
  unloadable
  require_login :only => [:edit_profile, :edit_email_addresses, :change_password]
  before_filter :check_signup_allowed, :only => [:signup, :signup_success]
  
  filter_parameter_logging :password
  
  def activate
    if logged_in?
      redirect_to "/"
      return
    end

    @account = Account.find params[:account]

    if not @account.nil? and @account.activation_key == params[:activation_key]
      @account.active = true
      @account.activation_key = nil
      @account.save
    else
      redirect_to :action => :activation_error
    end
  end
  
  def edit_profile
    @person = logged_in_person
    if not AeUsers.profile_class.nil?
      @app_profile = AeUsers.profile_class.find_by_person_id(@person.id)
    end
    
    if request.post?
      @person.update_attributes params[:person]
      if @app_profile
        @app_profile.update_attributes params[:app_profile]
      end
    end
  end
  
  def edit_email_addresses
    errs = []
    
    if params[:new_address] and params[:new_address].length > 0
      existing_ea = EmailAddress.find_by_address params[:new_address]
      if existing_ea
        errs.push "A different person is already associated with the email address you tried to add."
      else
        newea = EmailAddress.create :person => logged_in_person, :address => params[:new_address]
        if params[:primary] == 'new'
          newea.primary = true
          newea.save
        end
      end
    end
    
    if params[:primary] and params[:primary] != 'new'
      id = params[:primary].to_i
      if id != 0
        addr = EmailAddress.find id
        if addr.person != logged_in_person
          errs.push "The email address you've selected as primary belongs to a different person."
        else
          addr.primary = true
          addr.save
        end
      else
        errs.push "The email address you've selected as primary doesn't exist."
      end
    end
    
    if params[:delete]
      params[:delete].each do |id|
        addr = EmailAddress.find id
        if addr.person != logged_in_person
          errs.push "The email address you've selected to delete belongs to a different person."
        elsif addr.primary
          errs.push "You can't delete your primary email address.  Try making a different email address your primary address first."
        else
          addr.destroy
        end
      end
    end
    
    if errs.length > 0
      flash[:error_messages] = errs
    end
    
    redirect_to :action => :edit_profile
  end
  
  def change_password
    password = params[:password]
    if password[:password1].nil? or password[:password2].nil?
      redirect_to :action => :edit_profile
    elsif password[:password1] != password[:password2]
      flash[:error_messages] = ["The passwords you entered don't match.  Please try again."]
      redirect_to :action => :edit_profile
    else
      acct = logged_in_person.account
      acct.password = password[:password1]
      acct.save
    end
  end
  
  def activation_error
  end
  
  def signup_success
  end
  
  def signup
    ret = create_account_and_person()
    if ret == :success
      redirect_to :action => 'signup_success'
    elsif ret == :no_activation
      redirect_to :action => :signup_noactivation
    end
  end
  
  private  
  def check_signup_allowed
    if not AeUsers.signup_allowed?
      access_denied "Account signup is not allowed on this site."
    end
  end
end
