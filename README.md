# rad-consumer

Consumer search for the Retirement Adviser Directory **(Headerless Branch)**
**See below for deployment instructions**

## Prerequisites

- [Ruby 2.6.5](http://www.ruby-lang.org/en)
- [Node.js](http://nodejs.org/)
- [PostgreSQL](http://www.postgresql.org/)

## Installation

Make sure all dependencies are available to the application:

```sh
npm install
npm install bower -g
bundle install
bundle exec bowndler update
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
bundle exec rake db:create
bundle exec rake db:schema:load
bundle exec rake db:seed
bundle exec rake db:test:prepare
```

#### Production/Test Algolia Indices

If you want to consume the production indices, you need to change
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

Some of the tests use cassettes rather than calling algolia. The env vars are
in the .env.test file. Login into the algolia app using the credentials on keePassX and find
the ALGOLIA_APP_KEY for the ALGOLIA_APP_ID supplied in the .env.test file.

Then run:
```sh
$ bundle exec cucumber
```

To run the javascript tests:

```
$ node_modules/.bin/karma start spec/javascripts/karma.conf.js --single-run=true
```

## Deployment

**The **feature/NTT_Rebased** branch of rad_consumer is for mounting in AEM only.**
During the transition period between the MAS legacy estate and the completion of the 321 program we will have two environments for rad_consumer.  The first Heroku environment, `rad-consumer-production` allows rad_consumer to be mounted in the MAS legacy site, and is linked to the master branch of this repo.  The second environment, `rad-consumer-aem-321`, is linked to the `feature/NTT_Rebased` branch, and allows the tool to be mounted in the new moneyhelper domain.  This latter branch includes all the CSS/styling for the new site.  Most importantly the headers and footers have been removed.

### Adding the remote for rad-consumer-aem-321

From the console navigate to your local copy of this repo and add two (new) remotes:
```sh
$ cd rad_consumer
$ heroku git:remote -a rad-consumer-aem-321 --remote rad-consumer-aem-321
$ heroku git:remote -a mas-rad-consumer-preview --remote mas-rad-consumer-preview
```

Verify this using the following code

```sh
$ git remote -v
  mas-rad-consumer-preview	https://git.heroku.com/mas-rad-consumer-preview.git (fetch)
  mas-rad-consumer-preview	https://git.heroku.com/mas-rad-consumer-preview.git (push)
  mas-rad-consumer-staging	https://git.heroku.com/mas-rad-consumer-staging.git (fetch)
  mas-rad-consumer-staging	https://git.heroku.com/mas-rad-consumer-staging.git (push)
  rad-consumer-aem-321	    https://git.heroku.com/rad-consumer-aem-321.git (fetch)
  rad-consumer-aem-321	    https://git.heroku.com/rad-consumer-aem-321.git (push)
  rad-consumer-production	https://git.heroku.com/rad-consumer-production.git (fetch)
  rad-consumer-production	https://git.heroku.com/rad-consumer-production.git (push)
```

### Deployment process

Note that this process is for changes to rad_consumer only.  If your change requires update to `rad` as well please refer to the deployment docs in that repo.
When changes are made that apply to both the MAS and moneyhelper site you will need to merge your changes into both the `master` branch and the `feature/NTT_Rebased` branch.  Create a pull request for each branch, and resolve any conflicts that occur.  In order to deploy your changes you will need to push to both remotes.

Push first to the MAS staging environment:

```sh
$ git push mas-rad-consumer-staging master
```

Once this has built you can deploy to the AEM preview environment:

```sh
$ git push mas-rad-consumer-preview feature/NTT_Rebased:master
```

When your changes have been approved you can deploy to production.  As before deploy to MAS first:

```sh
$ git push git push rad-consumer-production master
```

Once this has built you can deploy to the AEM prodiction environment:

```sh
$ git push rad-consumer-aem-321 feature/NTT_Rebased:master
```

### Partials Removed

The NTT branch has the following partials removed from `application.html.erb`:

- breadcrumbs
- footer
- header
- maps_banner
- covid_banner


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

[Technical Docs](https://github.com/moneyadviceservice/technical-docs/tree/master/rad)
