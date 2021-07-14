ENGLISH_EMBED_URL = 'https://www.moneyhelper.org.uk/en/pensions-and-retirement/taking-your-pension/find-a-retirement-adviser'.freeze
WELSH_EMBED_URL   = 'https://www.moneyhelper.org.uk/cy/pensions-and-retirement/taking-your-pension/find-a-retirement-adviser'.freeze

Rails.application.routes.draw do
  # these would match legacy, non-embed URLs
  constraints(MasRedirectConstraints.new(redirect: true)) do
    get '/', to: redirect(ENGLISH_EMBED_URL)

    get '/en(*all)', to: redirect(ENGLISH_EMBED_URL)
    get '/cy(*all)', to: redirect(WELSH_EMBED_URL)
  end

  # these will continue to be served from the embed URLs
  constraints(MasRedirectConstraints.new(redirect: false)) do
    get '/' => redirect('/en')

    scope '/:locale', locale: /en|cy/ do
      root 'landing_page#show'

      get '/search', to: 'search#index'
      get '/glossary', to: 'glossary#show'

      resources :firms, only: [:show]
    end
  end
end
