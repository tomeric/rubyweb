class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '????? you'll need to sort this out yourself!'
  
  include AuthenticatedSystem
  
  protected
  
  def items_per_page
    30
  end
  helper_method :items_per_page
  
  def render_404
    render(:status => 404, :text => '404 Not Found')
  end
  
  def render_403
    render(:status => 403, :text => '403 Forbidden')    
  end
  
  # do_pagination is used in before_filters by actions that use pagination
  # If a "page" param is provided, use that to set the page, otherwise assume we're on page 1
  # Then set up a pagination_options hash that can be used with 'find' to sort out the SQL!
  # If param "all" is set, pagination is forgotten and ALL items should be returned
  def do_pagination
    @page_number = 1
    if params[:page] && params[:page].to_i > 0
      @page_number = params[:page].to_i
    end
    @pagination = true
    @pagination_options = { :limit => items_per_page, :offset => (@page_number - 1) * items_per_page }
    @pagination_options = {} if params[:all]
  end
end
