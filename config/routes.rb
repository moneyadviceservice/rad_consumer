Rails.application.routes.draw do
  get '/' => redirect('/en')

  scope '/:locale', locale: /en|cy/ do
    root 'landing_page#show'

    get '/search', to: 'landing_page#search'
  end
end
