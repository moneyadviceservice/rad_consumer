Rails.application.routes.draw do
  root 'landing_page#show'

  post '/search', to: 'landing_page#search'
end
