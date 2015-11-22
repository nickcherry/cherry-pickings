---
public_id: letting-your-javascript-speak-freely-with-humps
title: Letting Your Javascript Speak Freely with Humps
tags: [javascript, angular]
published: true
---

<a title="Google Style Guide" href="https://google.github.io/styleguide/jsoncstyleguide.xml?showone=Property_Name_Format#Property_Name_Format" target="_blank">Google's style guide</a> may technically endorse camelCase for API responses, but <a title="Pinterest API" href="https://developers.pinterest.com/tools/api-explorer/" target="_blank">the</a> <a title="Twitter API" href="https://dev.twitter.com/rest/public" target="_blank">internet</a> <a title="Facebook API" href="https://developers.facebook.com/docs/graph-api/overview" target="_blank">at</a> <a title=
"Instagram API" target="_blank" href="https://instagram.com/developer/">large</a> (<a title="Google Places API" target="_blank" href="https://developers.google.com/places/web-service/">Google included</a>) seems to prefer snake_case. Personally, I'm a fan. In addition to being a natural fit for languages like Ruby, <a title="An Eye Tracking Study on camelCase and
under_score Identifier Styles" href="http://www.cs.kent.edu/~jmaletic/papers/ICPC2010-CamelCaseUnderScoreClouds.pdf">one study</a> found that snake_case is generally more readable. There's just one minor dilemma, which you may have encountered yourself while working with API-oriented projects:

> The server prefers to communicate in snake_case, but our javascript longs for camelCase. Whose idiosyncracies do we embrace???

<figure>
  <figcaption>My response:</figcaption>
  <a title="Why not both?" href="/examples/the-perfect-fade/1" target="_blank"><img src="/images/posts/why-not-both.gif" alt="Why not both?"></a>
</figure>

<a title="Humps" target="_blank" href="https://github.com/domchristie/humps">Humps</a> is a handy little javascript library that recursively converts javascript object keys between camelCase and snake_case. If we're using Angular, we can configure `$httpProvider` to decamelize (i.e. snake_case) all outgoing request data and to camelize incoming response data. As a result, both our client and server can write in their native tongues and still communicate effectively with one another!

To get this working, first we'll want to pull down Humps (`bower install humps`) and include it in our project. Then, we'll do the following in the application config:

```coffeescript
angular.module('myLovelyLumps', []).config ($httpProvider) ->

  $httpProvider.defaults.transformRequest.unshift (data) ->
    humps.decamelizeKeys(data)

  $httpProvider.defaults.transformResponse.push (data) ->
    humps.camelizeKeys(data)
```

Note that for `transformRequest` we `unshift` our function to the beginning of the array, and for `transformResponse` we `push` the function to the end. In both cases, the reasoning is that we want to work with javascript objects, rather than the stringified JSON, which travels over the network. For requests, we want to decamelize our keys *before* everything gets turned into a string, and for responses, we want to wait until *after* Angular has parsed the server's response into a nice javascript object for us.

