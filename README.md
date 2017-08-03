# rad-consumer

Consumer search for the Retirement Adviser Directory

![Build Status](https://travis-ci.org/moneyadviceservice/rad_consumer.svg?branch=master)

## Prerequisites

* [Git](http://git-scm.com)
* [Ruby 2.2.2](http://www.ruby-lang.org/en)
* [Rubygems 2.2.2](http://rubygems.org)
* [Node.js](http://nodejs.org/)
* [Bundler](http://bundler.io)
* [PostgreSQL](http://www.postgresql.org/)
* [Elasticsearch 1.5 or 1.7](https://www.elastic.co/products/elasticsearch) - install with `brew install elasticsearch17`
* [RAD](https://github.com/moneyadviceservice/rad) (for PostgreSQL set up)
* [mas-rad_core](https://github.com/moneyadviceservice/mas-rad_core) 
* [mas-cms-client] (https://github.com/moneyadviceservice/mas-cms-client)

## Installation

Clone the repository:

```sh
$ git clone https://github.com/moneyadviceservice/rad_consumer.git
```

Make sure all dependencies are available to the application:

```sh
$ bundle install
$ bundle exec bowndler update
$ npm install
```

---

**NOTES:
This application shares access to a PostgreSQL database with the rad
project. DO NOT install the database from here. Instead install
[rad](https://github.com/moneyadviceservice/rad) first as this contains all the
extra seed data required.

This application uses the public [mas-rad_core](https://github.com/moneyadviceservice/mas-rad_core) 
gem to enable authorised users to manipulate the advisor directory data. Many of the tests in rad-consumer 
use the factories defined in mas-rad_core.

**

---


### Set up database

Setup the database connection:

```sh
$ cp config/example.database.yml config/database.yml
```
Be sure to remove or modify the `username` attribute.

Download a backup of the Production DB and load it into your local DB. Follow the instructions for how to [load it into your local development database here:](https://maswiki.valiantyscloud.net/pages/viewpage.action?pageId=63635527)

### Set up Elasticsearch

Make sure Elasticsearch is running.

__After starting Elasticsearch, verify the version - if you navigate to http://localhost:9200/ the `version.number` should be 1.7.x__

Push the index by running the following command. For the production environment replace `rad_development` with
`rad_production`:

```sh
$ curl -XPOST http://127.0.0.1:9200/rad_development -d @elastic_search_mapping.json
```

Once you've pushed the index, run the following rake task to populate it:
```sh
bundle exec rake firms:index
```
If you navigate to your [local Elasticsearch instance](http://localhost:9200/rad_development/firms/_search) you should now be able to see the list of firms.

There are additional notes on Elasticsearch tasks on the [MAS wiki](https://maswiki.valiantyscloud.net/display/RRAD/Elasticsearch+Tasks)

### Google Maps API

For the firm profile maps to work, you will need to provide a Google Maps API
key in `.env`. You can find an example at `.env.example`.

### Sharia and Ethical Investment

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

To run the Ruby tests:

```sh
$ bundle exec rspec
```

To run the javascript tests:

```
$ node_modules/.bin/karma start spec/javascripts/karma.conf.js --single-run=true
```

## Contributing
1. Set up the application, run all the tests and ensure you can successfully run 
the application
2. Create a feature branch. 
3. Make your changes, ensure all changes include appropriate test coverage.
4. Run rubocop and ensure all cops pass.
5. Push your feature branch and create a pr.
