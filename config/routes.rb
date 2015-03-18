Rails.application.routes.draw do
  get '/' => redirect('/en')

  scope '/:locale', locale: /en|cy/ do
    root 'landing_page#show'

    get '/search', to: 'search#index'
    get '/glossary', to: 'glossary#show'
  end
end
