# Cherry-Pickings

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
```

### Starting the Server

To start the development server, run the following command:

```shell
rails s
```

Then visit [http://localhost:3000](http://localhost:3000) in a browser to view the app.
