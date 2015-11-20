---
public_id: token-authentication-with-angular-and-rails
title: Token Authentication with Angular and Rails
tags: [angular, rails, nginx, authentication]
published: true
---

Few developers would describe authentication as the most glamorous feature they've ever implemented, but it comes up a lot. With traditional web applications, keeping track of logged in users [is relatively straightforward](http://www.theodinproject.com/ruby-on-rails/sessions-cookies-and-authentication). While authenticating API requests isn't rocket science, the solution might not be as immediately obvious. Today we're going to walk through a simple, reusable strategy that's served me well in authenticating requests between Angular and Rails. :lock:

<a href="https://docs.angularjs.org/api/ng/service/$http" target="_blank">Interceptors</a> are services that enable us to tap into and manipulate any request or response that goes through Angular's `$http` module. I know what you're probably thinking right now:

> That would make them perfect candidates for authenticating API requests and handling 401 responses gracefully!!!!!

And I am nodding in agreement. Now you might be wondering:

> But how do we actually **do** that???

I'm glad you asked! On the front-end, we're going to do it like this:

1. Assume the user has logged in and that we've assigned the server's response (auth token included) to `rootScope.currentUser`:

    ```coffeescript
    formData = { username: 'dukesilver@aol.com', password: 'MeatTornado' }
    new SessionResource().create(formData).then (response) ->
      $rootScope.currentUser = response.data
      # { id: 1, name: 'Ron Swanson', authToken: '1234567890' }
    ```
2. Create an `AuthInterceptor` service, which will implement two methods:
  <ul>
    <li>
      __request__
      <ul>
        <li>invoked before every `$http` request the app makes</li>
        <li>receives a `config` argument, which describes the soon-to-be request</li>
        <li>for our purposes, merges the authenticated user's auth token into `config.headers`, then returns the resulting object</li>
      </ul>
    </li>
    <li>
      __responseError__
      <ul>
        <li>invoked any time the server responds to an `$http` request with an error</li>
        <li>receives a `response` argument, which encapsulates the server's response</li>
        <li>for our purposes, redirects the user to the sign-in page in the event of a 401 (unauthenticated) status code</li>
        <li>returns a rejected promise, because we're not going to rescue the error</li>
      </ul>
    </li>
  </ul>
3. In the app's `config` block, tell `$httpProvider` to use the `AuthInterceptor` :point_up: we discussed above.


  ```coffeescript
  angular.module('app', [])

    .config ($httpProvider) ->
      $httpProvider.interceptors.push 'AuthInterceptor'

    .service 'AuthInterceptor', ($location, $q, $rootScope) ->
      interceptor =

        request: (config) ->
          angular.extend config,
            headers:
              AUTH_TOKEN: $rootScope.currentUser?.authToken

        responseError: (response) ->
          if response.status == 401 && $location.path() != '/sign-in'
            $location.path '/sign-in'
          $q.reject(response)
  ```

And there we have it! With a baker's dozen lines of code, our Angular app is including the user's auth code with every request _and_ redirecting to sign-in if authentication ever fails. Pretty sweet, huh? :cake:

Now that our front-end is taken care of, let's whip up the server-side code. In Rails, we can implement a base `ApiController` from which all of our API controllers can inherit. For each incoming request, we'll validate the auth token; if the token checks out, the request will go through as usual, otherwise we'll respond with a 401. If we ever want to bypass authentication, we can just do something like `skip_before_action :authenticate!, only: [:sign_in]` for the relevant child controller.

```ruby
class ApiController < ApplicationController

  layout false
  respond_to :json

  before_action :authenticate!

  def current_user
    @current_user ||= User.find_by(auth_token: auth_token) if auth_token.present?
  end

protected

  def auth_token
    @auth_token ||= request.headers['HTTP_AUTH_TOKEN']
  end

  def authenticate!
    current_user || render_unauthenticated!
  end

  def render_unauthenticated!
    render json: { error: 'Authentication failed' }, root: false, status: 401
    false
  end

end
```

You may have noticed that while we defined our header as `AUTH_TOKEN` in the Angular world, the key we referenced in Ruby was prefixed by `HTTP_`. This is [just something that Rails does](https://github.com/rails/rails/blob/master/actionpack/lib/action_dispatch/http/headers.rb#L108-L111) to prevent naming conflicts. Another _gotcha_ to be aware of, if you have Nginx sitting in front of your server, is explained quite well [in their documentation of pitfalls and common mistakes](https://www.nginx.com/resources/wiki/start/topics/tutorials/config_pitfalls/#missing-disappearing-http-headers):

> If you do not explicitly set underscores_in_headers on, NGINX will silently drop HTTP headers with underscores (which are perfectly valid according to the HTTP standard). This is done in order to prevent ambiguities when mapping headers to CGI variables as both dashes and underscores are mapped to underscores during that process.

The more you know. Anywho, now that we have a good pattern for securing out API, we can spend less time fiddling with authentication and more time focusing on the fun stuff! :tada:
