# rad-consumer

Consumer search for the Retirement Adviser Directory

![Build Status](https://travis-ci.org/moneyadviceservice/rad_consumer.svg?branch=master)

## Prerequisites

- [Ruby 2.5.3](http://www.ruby-lang.org/en)
- [Node.js](http://nodejs.org/)
- [Bundler](http://bundler.io)
- [PostgreSQL](http://www.postgresql.org/)

## Installation

Make sure all dependencies are available to the application:

```sh
$ bundle install
$ bundle exec bowndler update
$ npm install
```

### Set up database

Additionally, you need to setup the database connection to the database:

```sh
$ cp config/example.database.yml config/database.yml
```

Be sure to remove or modify the `username` attribute if it needs to be,
then run:

Make sure Postgres is running, then run:

```sh
$ bundle exec rake db:create \
  && for env in development test; do RAILS_ENV=$env bundle exec rake db:migrate; done
```

#### Production/Test Algolia Indeces

If you want to consume the production indeces, you need to change
`ALGOLIA_APP_ID` and `ALGOLIA_API_KEY` accordingly in [config/initializers/algoliasearch.rb](config/initializers/algoliasearch.rb)

### Google Maps API

For the firm profile maps to work, you will need to provide a Google Maps API
key in `.env`. You can find an example at `.env.example`.

### Google Geocoder API

For the firms search by postcode to work, you will need to provide a Google Geocoder API
key in `.env`. You can find an example at `.env.example`.

Alternatively, you can stub the Geocoder to return an array of predetermined coordinates. i.e:

```ruby
class Geocode
  def self.call(postcode)
    # Geocoder.coordinates("#{postcode}, United Kingdom")
    # i.e. London
    [51.5074, 0.1278]
  end
end
```

or set the `lookup` to `:test` and provide a stub. More info [here](https://github.com/alexreisner/geocoder)

### Sharia and Ethical Investment

The search option provides a filter for targeting sharia and ethical investment
firms. These investment search options can be activated for the RAD Consumer
application by setting the feature flag. You can find an example at
`.env.example`.

## Usage

Start the application:

```sh
$ bundle exec rails s
```

Then navigate to [http://localhost:3000/](http://localhost:3000/) to access the
application locally.

### Running the Tests

To run the RSpec tests:

```sh
$ bundle exec rspec
```

To run the Cucumber tests:

```sh
$ bundle exec cucumber
```

To run the javascript tests:

```
$ node_modules/.bin/karma start spec/javascripts/karma.conf.js --single-run=true
```

## Limitations

### Stylesheets

As `rad_consumer` exists outside of the frontend project it is required that the
frontend production CSS is linked to in order to inherit properties for the
following elements:

- Header Styles
- Footer Styles
- Layout (Constrained)
- Colours

## Contributing

1. Set up the application, run all the tests and ensure you can successfully run
   the application
2. Create a feature branch.
3. Make your changes, ensure all changes include appropriate test coverage.
4. Run rubocop and ensure all cops pass.
5. Push your feature branch and create a pr.
