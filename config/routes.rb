ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'items'

  # artikels
  map.resources :items,
                :as         => 'artikels',
                :path_names => { :new  => 'nieuw',
                                 :edit => 'wijzig' } do |item|
  
    # reacties
    item.resources :comments,
                   :as         => 'reacties',
                   :path_names => { :new  => 'nieuw',
                                    :edit => 'wijzig' }
  end

  map.connect '/pagina/:page', :controller => 'items', :action => 'index'

  map.resources :forgetful_users,
                :as         => 'inloggegevens',
                :path_names => { :new  => 'vergeten',
                                 :edit => 'herstellen' }

  map.resources :users,
                :as         => 'gebruikers',
                :member     => { :approve    => :put,
                                 :disapprove => :put },
                :path_names => { :new        => 'nieuw',
                                 :edit       => 'wijzig',
                                 :destroy    => 'verwijder',
                                 :approve    => 'goedkeuren',
                                 :disapprove => 'afkeuren' }

  map.resource :session, :controller => 'session'  
  
  map.reset_password '/inloggegevens/:id/herstellen/:token',
                     :controller => 'forgetful_users',
                     :action     => 'edit'
  
  map.signup '/registreren',
             :controller => 'users',
             :action     => 'new'

  map.login '/inloggen',
            :controller => 'session',
            :action     => 'new'

  map.logout '/uitloggen', :controller => 'session', :action => 'destroy'
end
