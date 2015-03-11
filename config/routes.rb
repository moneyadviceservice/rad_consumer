Rails.application.routes.draw do
  get '/' => redirect('/en')

  scope '/:locale', locale: /en|cy/ do
    root 'landing_page#show'

    get '/search', to: 'search#index'
    get '/remote-help-search', to: 'remote_search#index', as: :search_remote_advice
  end
end
