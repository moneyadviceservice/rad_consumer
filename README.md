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
* [Elasticsearch >= 1.2](https://www.elastic.co/products/elasticsearch)
* [RAD](https://github.com/moneyadviceservice/rad) (for PostgreSQL set up)

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

**NOTE this application shares access to a PostgreSQL database with the rad
project. DO NOT install the database from here. Instead install
[rad](https://github.com/moneyadviceservice/rad) first as this contains all the
extra seed data required.**

---

Setup the database connection:

```sh
$ cp config/example.database.yml config/database.yml
```

Be sure to remove or modify the `username` attribute.

Make sure Elasticsearch is running.

Push the index. For the production environment replace `rad_development` with
`rad_production`:

```sh
$ curl -XPOST http://127.0.0.1:9200/rad_development -d @elastic_search_mapping.json
```

Once you've pushed the index, run the following rake task to populate it:
```sh
rake firms:index
```

For the firm profile maps to work, you will need to provide a Google Maps API
key in `.env`. You can find an example at `.env.example`.

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
