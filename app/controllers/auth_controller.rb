class AuthController < ApplicationController
  unloadable
  filter_parameter_logging :password
  before_filter :construct_login, :only => [:login, :forgot_form]
  
  def index
    respond_to do |format|
      format.css { render :layout => false }
    end
  end
  
  def login
    if request.post?
      unless @login.password or @login.have_password
        return redirect_to(:controller => "account", :action => "signup", :email => @login.email)
      end
      
      unless logged_in?
        if attempt_login(@login)
          successful_login_redirect
        end
      end
    end
  end

  def auth_form  
    respond_to do |format|
      format.js { render :layout => false }
    end
  end
  
  def needs_profile
    @person = Person.find session[:provisional_person]
    if @person.nil?
      flash[:error_messages] = ["Couldn't find a person record with that ID.  
        Something may have gone wrong internally.  Please try again, and if the problem persists, please contact
        the site administrator."]
      return redirect_to(:back)
    end
    
    if not AeUsers.signup_allowed?
      flash[:error_messages] = ['Your account is not valid for this site.']
      redirect_to url_for("/")
    else
      if not AeUsers.profile_class.nil?
        @app_profile = AeUsers.profile_class.send(:new, :person_id => session[:provisional_person])
        @app_profile.attributes = params[:app_profile]
        
        if request.post?
          @app_profile.save
          session[:person] = @person
          redirect_to params[:return_to]
        end
      end
    end
  end
  
  def forgot
    ActionMailer::Base.default_url_options[:host] = request.host
    
    @account = Account.find_by_email_address(params[:email])
    if not @account.nil?
      @account.generate_password
    else
      flash[:error_messages] = ["There's no account matching that email address.  Please try again, or sign up for an account."]
      redirect_to :action => :forgot_form
    end
  end
  
  def resend_validation
    ActionMailer::Base.default_url_options[:host] = request.host
    
    @email_address = Account.find params[:email]
    if not @email_address.nil?
      @email_address.generate_validation
    else
      flash[:error_messages] = ["Email address #{params[:email]} not found!"]
      redirect_to url_for("/")
    end
  end
  
  def logout
    reset_session
    redirect_to :back
  end
  
  private
  
  def construct_login
    @login = Login.new(params[:login])
    @login.email ||= cookies['email']
    if @login.return_to.nil? or @login.return_to == ""
      if params[:return_to]
        @login.return_to = params[:return_to]
      else
        @login.return_to = request.env["HTTP_REFERER"]
      end
    end

    # prevent infinite redirect loops
    begin
      if URI(@login.return_to).path == URI(request.url).path
        @login.return_to = url_for("/")
      end
    rescue
    end
    
    # if they're already logged in, don't let them view this page
    if logged_in?
      successful_login_redirect
    end
  end
  
  def successful_login_redirect
    if @login.return_to
      redirect_to @login.return_to
    elsif session[:return_to]
      rt = session[:return_to]
      session[:return_to] = nil
      redirect_to rt
    else
      redirect_to url_for('/')
    end
  end
end
