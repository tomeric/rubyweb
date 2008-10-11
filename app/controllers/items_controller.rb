class ItemsController < ApplicationController
  before_filter :login_required,
                :except => [:show, :index, :new, :create]
  
  before_filter :load_item,
                :only => [:show, :edit, :update, :destroy]
  
  before_filter :permission_required,
                :only => [:edit, :update]

  before_filter :admin_required,
                :only => [:destroy]

  before_filter :do_pagination,
                :only => [:index]

  # GET /artikels
  # GET /artikels.xml
  # GET /artikels.rss
  def index
    @items_count = Item.count
    @items       = Item.find(:all, { :order => 'items.created_at DESC', :include => :user }.merge(@pagination_options))

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @items }
      format.rss { render :layout => false }
    end
  end

  # GET /artikels/1
  # GET /artikels/1.xml
  def show
    @comment = Comment.new(params[:comment])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @item }
      format.json { render :json => @item }
    end
  end

  # GET /artikels/nieuw
  # GET /artikels/nieuw.xml
  def new
    @item = Item.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @item }
    end
  end

  # GET /artikels/1/wijzig
  def edit
  end

  # POST /artikels
  # POST /artikels.xml
  def create
    @item = Item.new(params[:item])
    
    if logged_in?
      @item.user = current_user
    else
      @item.anonymous!
      
      unless verify_recaptcha
        flash.now[:error] = 'Het woord dat je hebt overgetikt komt niet overeen met het woord dat werd weergegeven. Probeer het opnieuw met het juiste woord.'

        render(:action => 'new') and return
      end        
    end
    
    respond_to do |format|
      if @item.save
        flash[:notice] = 'Artikel is succesvol aangemaakt.'
        format.html { redirect_to(@item) }
        format.xml  { render :xml => @item, :status => :created, :location => @item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /artikels/1
  # PUT /artikels/1.xml
  def update  
    respond_to do |format|
      if @item.update_attributes(params[:item])
        flash[:notice] = 'Artikel is succesvol ge-update.'
        format.html { redirect_to(@item) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /artikels/1
  # DELETE /artikels/1.xml
  def destroy
    @item.destroy

    respond_to do |format|
      format.html { redirect_to(items_url) }
      format.xml  { head :ok }
      format.json { head :ok }
    end
  end
  
  protected
  
  # Load's the item before an action is executed. If the item is not found, 
  # render a 404.
  def load_item
    @item = Item.find(params[:id]) rescue Item.find_by_name(params[:id])
    
    render_404 unless @item
  end

  # Check if an item can be edited by the current user. If not, render a 403.
  def permission_required    
    render_403 unless admin? || @item.is_editable_by(current_user)
  end
end