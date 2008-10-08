class CommentsController < ApplicationController
  before_filter :admin_required, :except => [:create]
  before_filter :load_item
  
  # GET /item/1/comments/1/edit
  def edit
    @comment = @item.comments.find(params[:id])
  end

  # POST /item/1/comments
  # POST /item/1/comments.xml
  def create
    @comment = @item.comments.new(params[:comment])
    
    if logged_in?
      @comment.user = current_user
    else
      @comment.byline  = "Anonieme Bangerd" if @comment.byline.empty?
      @comment.content = @comment.content.gsub(/((<a\s+.*?href.+?\".*?\")([^\>]*?)>)/, '\2 rel="nofollow" \3>')
      
      unless verify_recaptcha
        @item.errors.add("Word")
        flash.now[:notice] = "Je reactie kon niet geplaatst worden. Scroll naar beneden, corrigeer en probeer het opnieuw. Heb je de CAPTCHA correct overgetikt?"
        render :template => 'items/show'
        return
      end
    end   

    respond_to do |format|
      if @comment.save
        flash[:notice] = 'Reactie is succesvol geplaatst.'
        format.html { redirect_to(@comment.item) }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        flash.now[:notice] = "Je reactie kon niet geplaatst worden. Scroll naar beneden, corrigeer en probeer het opnieuw."
        format.html { render :template => 'items/show' }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /item/1/comments/1
  # PUT /item/1/comments/1.xml
  def update
    @comment = @item.comments.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        flash[:notice] = 'Comment was successfully updated.'
        format.html { redirect_to(@comment) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /item/1/comments/1
  # DELETE /item/1/comments/1.xml
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to(comments_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
  
  def load_item
    @item = Item.find(params[:item_id])
  end
end
