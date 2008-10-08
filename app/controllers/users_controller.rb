class UsersController < ApplicationController
  before_filter :load_user,
                :only => [:show, :edit, :update, :destroy, :approve, :disapprove]

  before_filter :admin_required,
                :only => [:index, :approve, :disapprove, :destroy]

  before_filter :permission_required,
                :only => [:edit, :update]
    
  def new
    @user = User.new(params[:user])
  end

  def create
    cookies.delete :auth_token
    
    @user = User.new(params[:user])
    unless verify_recaptcha
      flash.now[:error] = 'Het woord dat je hebt overgetikt komt niet overeen met het woord dat werd weergegeven. Probeer het opnieuw met het juiste woord.'
      render :action => 'new'
      return
    end    

    @user.save
    if @user.errors.empty?
      self.current_user = @user
      redirect_back_or_default('/')
      flash[:notice] = 'Bedankt voor het registreren! Je bent nu automatisch ingelogd.'
    else
      render :action => 'new'
    end
  end
  
  def index
    @users = User.find(:all, :order => 'id DESC')
  end
  
  def edit
  end
  
  def update
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = admin? ? "De gegevens van #{@user.login} zijn aangepast." : 'Je gegevens zijn aangepast.'
        format.html { redirect_to(root_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def approve
    @user.update_attribute(:approved_for_feed, true)

    redirect_to :back
  end

  def disapprove
    @user.update_attribute(:approved_for_feed, false)

    redirect_to :back
  end
  
  def destroy
    return unless request.delete?
    
    if User.destroy(params[:id])
      flash[:notice] = 'De gebruiker is verwijderd.'
    else
      flash[:error] = 'De gebruiker kon niet verwijderd worden.'
    end
    
    redirect_to :action => 'index'
  end
  
  protected
  
  def load_user
    @user = User.find(params[:id]) rescue render_404
  end
  
  # Check if an item can be edited by the current user. If not, render a 403.
  def permission_required    
    render_403 unless admin? || @user == current_user
  end
end
