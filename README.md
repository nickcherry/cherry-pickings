
[![Build Status](http://circleci-badges-max.herokuapp.com/img/nickcherry/cherry-pickings/master?token=351b5349fa74fed8aecae1e81dcd6289aae936f1)](https://circleci.com/gh/nickcherry/cherry-pickings/tree/master)

# Cherry-Pickings

Ma blog!

## Development Setup

### Installing Dependencies

After installing [Ruby](https://www.ruby-lang.org/en/), [Bundler](http://bundler.io/), and [Postgres](http://www.postgresql.org/), run the following from the project's root to install gem dependencies:

```shell
bundle install
```

Then, to install front-end [Bower](http://bower.io/) dependencies, run:

```shell
bower install
```

### Preparing the Database

To create, migrate, and seed a development database, run the following commands:

```shell
rake db:create
rake db:migrate
rake db:seed
rake posts:sync # syncs database with markdown posts found in db/posts
```

### Starting the Server

To start the development server, run the following command:

```shell
foreman start
```

Then visit [http://localhost:5000](http://localhost:5000) in a browser to view the app.

## Tests

First, be sure to prepare the test environment by running:

```shell
rake db:test:prepare
```

Then, to start the test suite:

```shell
rspec
```

If you'd like to watch for changes to specs and automatically run tests:

```shell
guard
```

## Deployment

Ensure that the Heroku app is configured to use the [Ruby-Bower buildpack](https://github.com/qnyp/heroku-buildpack-ruby-bower.git), [ImageMagick](https://github.com/ello/heroku-buildpack-imagemagick), and [Image-Optim](https://github.com/bobbus/image-optim-buildpack) buildpacks.

After every green commit to `master`, [CircleCI](https://circleci.com/gh/nickcherry/cherry-pickings/tree/master) will automatically deploy to Heroku, migrate the database, and sync databases posts with the markdown found in `db/posts`. This process can also be invoked manually by running the following rake task:

```shell
rake deploy:production
```

The production application lives at [http://www.nick-cherry.com](http://www.nick-cherry.com).
