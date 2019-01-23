# rad-consumer

Consumer search for the Retirement Adviser Directory

![Build Status](https://travis-ci.org/moneyadviceservice/rad_consumer.svg?branch=master)

## Prerequisites

* [Ruby 2.2.2](http://www.ruby-lang.org/en)
* [Node.js](http://nodejs.org/)
* [Bundler](http://bundler.io)
* [PostgreSQL](http://www.postgresql.org/)
* [Elasticsearch 1.5 or 1.7](https://www.elastic.co/products/elasticsearch)
* [RAD](https://github.com/moneyadviceservice/rad) (for PostgreSQL and Elasticsearch set up)

---

**NOTES:**

**This application shares _read_ access to a Postgres database and an
Elasticsearch instance with the `rad` project.**

**DO NOT install them from here. Instead install [rad](https://github.com/moneyadviceservice/rad)
first as this contains all the extra seed data required as well.**

**Acceptance tests in `rad_consumer` are also dependant on the above setup.**

**Please refer to the [Limitations](#limitations) section below for further info
regarding the consequences on development.**

---

## Installation

Make sure all dependencies are available to the application:

```sh
$ bundle install
$ bundle exec bowndler update
$ npm install
```

### Set up database

**Please make sure you have already followed the steps from [`rad`: Set up the database](https://github.com/moneyadviceservice/rad/blob/master/README.md#set-up-elasticsearch).**

Additionally, you need to setup the database connection to the shared database:

```sh
$ cp config/example.database.yml config/database.yml
```
Be sure to remove or modify the `username` attribute if it needs to be.

#### Production seeds

Download a backup of the Production DB and load it into your local DB.
Follow the instructions for how to [load it into your local development database here](https://maswiki.valiantyscloud.net/pages/viewpage.action?pageId=63635527).

### Set up Elasticsearch

**Please make sure you have already followed the steps from [`rad`: Set up Elasticsearch](https://github.com/moneyadviceservice/rad/blob/master/README.md#set-up-elasticsearch).**

No further steps required.

### Google Maps API

For the firm profile maps to work, you will need to provide a Google Maps API
key in `.env`. You can find an example at `.env.example`.

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

To run the javascript tests:

```
$ node_modules/.bin/karma start spec/javascripts/karma.conf.js --single-run=true
```

## Limitations

### Database

`rad_consumer` depends on 8 tables from the database owned by
the `rad` repository.

Their barebone models are defined in [app/models/db/](app/models/db).

As a consequence, every time a new migration that impacts any of these tables is
added to the `rad` repository, **the `schema.rb` needs to be updated on
`rad_consumer` as well**.

One easy way to do that is to run the following command in here:

```sh
$ bundle exec rake db:schema:dump
```

Please discard any changes that are not related to the new migration, e.g. tables
that are not used by `rad_consumer`.

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
