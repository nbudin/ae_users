class PersonSessionsController < ApplicationController
  unloadable
  
  before_filter :require_no_person, :only => [:new, :create]
  before_filter :require_person, :only => [:destroy]
  
  caches_page :index, :if => Proc.new { |c| c.request.format.css? }
  
  def index
    respond_to do |format|
      format.css { render :layout => false }
    end
  end
  
  def new
    @person_session = PersonSession.new
  end

  def create
    @person_session = PersonSession.new(params[:person_session])
    if @person_session.save
      redirect_to @person_session.return_to || url_for('/')
    else
      render :action => :new
    end
  end

  def destroy
    if person_session
      person_session.destroy
    end
    redirect_to new_person_session_url
  end
  
  private
  def require_no_person
    if person_session
      redirect_to :controller => 'account', :action => 'edit_profile'
    end
  end
  
  def require_person
    unless person
      redirect_to new_person_session_url(:person_session => { :return_to => request.request_uri })
    end
  end
end