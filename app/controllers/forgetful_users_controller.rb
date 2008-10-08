class ForgetfulUsersController < ApplicationController
  before_filter :fetch_user, :only => [:edit, :update]

  def new
    @user = User.new
  end
  
  def create
    if @user = User.find_by_email(params[:user][:email])
      Mailer.deliver_reset_password_mail(@user, reset_password_url(@user, @user.reset_password_token)) 
      
      flash[:notice] = 'Er zijn instructies opgestuurd naar je e-mailadres waarmee je je inloggegevens kan herstellen.'
      redirect_to root_url     
    else
      flash.now[:error] = "Voor het opgegeven e-mailadres zijn geen inloggegevens bekend. Controleer het e-mailadres en probeer het opnieuw."

      @user = User.new
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = "Je inloggegevens zijn aangepast, je kan nu inloggen met je nieuwe wachtwoord."
      redirect_to login_url
    else
      render :action => 'edit'
    end
  end
  
  protected
  
  def fetch_user
    @user = User.find(params[:id])
    
    unless @user.reset_password_token == params[:token]
      flash[:error] = "Ongeldige parameters. Vraag uw wachtwoord opnieuw aan om het opnieuw te proberen."
      redirect_to :action => 'new'
    end    
  end
end
