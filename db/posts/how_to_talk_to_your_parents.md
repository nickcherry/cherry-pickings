---
public_id: how-to-talk-to-your-parents-a-lesson-in-directive-communication
title: How to Talk to Your Parents (A Lesson in Directive Communication)
tags: [javascript, angular]
published: true
---

Directives are swell. They give us the power the build reusable, native-feeling components that function as the workhorses of many Angular applications. At the same time, they do have a reputation of being a little mysterious until you're accustomed to their ways. :crystal_ball: One challenge that causes many folks to scratch their heads is:

> How do we get our child directives to communicate with their parents???

Once Angular 2 comes out, <a href="http://blog.thoughtram.io/angular/2015/08/20/host-and-visibility-in-angular-2-dependency-injection.html" target="_blank">the answer to that question should be more standardized</a>, but in the meantime, there's no one right solution. Today we're going to go over four patterns that have served me well in past. There are pros and cons to each, and the best implementation will depend on the use case; so your mileage may very. Still, though, the more tools in your toolbox the better, right? :hammer: :wrench: :nut_and_bolt: :balloon:

Below you'll find a live demo of the app we're going to build. It's a simple drink-ordering system for Cherry Tavern. The establishment serves decent beverages, but the bartenders are notoriously unforgiving, hence the inability to remove items from your tab once you've ordered them. :wink:

<figure>
  <div class="iframe-wrapper">
    <iframe src="/examples/child-to-parent-directive-communication/shared-scope" frameborder="0" width="360" height="280" scrolling="no"></iframe>
  </div>
</figure>

Now let's see how we might go about programming this:

<hr>

### Shared Scope

The first strategy is the most straightforward: We can simply share a scope between our two directives. The parent says, "What's mine is yours!" and the child has access to every method the parent defines on `scope`. The important part to note is the `scope: true` in the child directive definition, <a href="https://github.com/angular/angular.js/wiki/Understanding-Scopes#directives" target="_blank">which signifies a shared scope</a>.

<ul>
  <li>
    <strong>Pros</strong>
    <ul>
      <li>
        Simplicity - less code, no need for configuration or variable hand-offs
      </li>
      <li>
        Efficiency - no additional callbacks or watchers
      </li>
    </ul>
  </li>
  <li>
    <strong>Cons</strong>
    <ul>
      <li>
        Less reusable - the child needs to conform to parent's interface
      </li>
      <li>
        Potential to pollute parent scope
      </li>
      <li>
        Implementation may be less obvious to team members, as opposed to strategies that explicitly define touchpoints between directives
      </li>
    </ul>
  </li>
</ul>

```html
<!-- store.html -->
<div class='store'>
  <item ng-repeat='item in items'></item>
  <div class='total'>
    <span class='value'>{{ total() | currency }}</span>
    <div class="summary">{{ summary() }}</div>
  </div>
</div>

<!-- item.html -->
<div class='item'>
  <button ng-click='addToCart(item)'>+</button>
  <span class='price'>{{ item.price | currency }}</span>
  <ng-emoticons emoticons-data='item.icon'></ng-emoticons>
  <span class='name'>{{ item.name }}</span>
</div>
```
```coffeescript
angular.module('cherryTavern')

  .directive 'store', (CartHelper)->
    config =
      scope: { items: '=' }
      templateUrl: 'store.html'
      link: (scope) ->
        cart = []
        scope.addToCart = (item) -> cart.push(item)
        scope.total = -> _.sum(cart, 'price')
        scope.summary = -> CartHelper.summarize(cart)

  .directive 'item', ->
    config =
      scope: true
      templateUrl: 'item.html'
```

<hr>

### Callbacks

In the next example, we're going to start the conversation by having the parent expose its `addToCart` method to the child. Notice that we're using <a href="http://weblogs.asp.net/dwahlin/creating-custom-angularjs-directives-part-3-isolate-scope-and-function-parameters" target="_blank"> an ampersand (&) in our isolated scope definition</a>, and our item template now needs to evaluate the `addToCart` expression before actually calling it.

<ul>
  <li>
    <strong>Pros</strong>
    <ul>
      <li>
        Reusable - the child can be adopted by any parent, so long as said parent provides the required arguments
      </li>
      <li>
        Declarative - all arguments are clearly defined in the child's configuration, making it easy for team members to understand what the directive needs to operate
      </li>
    </ul>
  </li>
  <li>
    <strong>Cons</strong>
    <ul>
      <li>
        Verbose and prone to silly errors, e.g. forgetting to provide arguments in the parent template, forgetting to whitelist a variable in the child's isolated scope
      </li>
      <li>
        Awkward double invocation syntax, e.g. <code>addToCart()(item)</code>
      </li>
    </ul>
  </li>
</ul>

```html
<!-- store.html -->
<div class='store'>
  <item ng-repeat='item in items'
    item="item"
    add-to-cart="addToCart">
  </item>
  <div class='total'>
    <span class='value'>{{ total() | currency }}</span>
    <div class="summary">{{ summary() }}</div>
  </div>
</div>

<!-- item.html -->
<div class='item'>
  <button ng-click='addToCart()(item)'>+</button>
  <span class='price'>{{ item.price | currency }}</span>
  <ng-emoticons emoticons-data='item.icon'></ng-emoticons>
  <span class='name'>{{ item.name }}</span>
</div>
```
```coffeescript
angular.module('cherryTavern')

  .directive 'store', (CartHelper) ->
    config =
      scope: { items: '=' }
      templateUrl: 'store.html'
      link: (scope) ->
        cart = []
        scope.addToCart = (item) -> cart.push(item)
        scope.total = -> _.sum(cart, 'price')
        scope.summary = -> CartHelper.summarize(cart)

  .directive 'item', ->
    config =
      scope: { item: '=', addToCart: '&' }
      templateUrl: 'item.html'
```

<hr>

### Required Controller

Some might say that our next pattern feels a bit like a hybrid of "Shared Scope" and "Callbacks". This time, rather than sharing a *scope* between parent/child directives, we're going to share a *controller*. The code that previously lived in our parent directive's `link` function will be <a href="http://blog.thoughtram.io/angularjs/2015/01/02/exploring-angular-1.3-bindToController.html" target="_blank">migrated to a controller</a>, then the child <a href="https://coderwall.com/p/14rwpg/angular-directive-accessing-the-controller" target="_blank">will require the parent controller</a> and expose the relevant method to its scope.

<ul>
  <li>
    <strong>Pros</strong>
    <ul>
      <li>
        Clear division of responsibilities
      </li>
      <li>
        Useful for communicating with grandparents, e.g. when the child in question isn't a direct descendent of the directive it needs to communicate with
      </li>
    </ul>
  </li>
  <li>
    <strong>Cons</strong>
    <ul>
      <li>
        A little extra configuration
      </li>
      <li>
        Less reusable - requires child directive to explicitly require the parent(s) it depends on
      </li>
    </ul>
  </li>
</ul>

```html
<!-- store.html -->
<div class='store'>
  <item ng-repeat='item in items'></item>
  <div class='total'>
    <span class='value'>{{ ctrl.total() | currency }}</span>
    <div class="summary">{{ ctrl.summary() }}</div>
  </div>
</div>

<!-- item.html -->
<div class='item'>
  <button ng-click='addToCart(item)'>+</button>
  <span class='price'>{{ item.price | currency }}</span>
  <ng-emoticons emoticons-data='item.icon'></ng-emoticons>
  <span class='name'>{{ item.name }}</span>
</div>
```

```coffeescript
angular.module('cherryTavern')

  .directive 'store', (CartHelper) ->
    class StoreController
      cart = [] # Let's keep this private
      addToCart: (item) -> cart.push(item)
      total: -> _.sum(cart, 'price')
      summary: -> CartHelper.summarize(cart)
    config =
      bindToController: { items: '=' }
      controller: StoreController
      controllerAs: 'ctrl'
      templateUrl: 'store.html'

  .directive 'item', ->
    config =
      require: '^store'
      templateUrl: 'item.html'
      link: (scope, element, attrs, storeController) ->
        scope.addToCart = storeController.addToCart
```

<hr>

### Events

In our last example, the child will fire an `item:addToCart` event and brush its hands off after a job well done. Meanwhile, the parent will be waiting patiently, then react accordingly when the event arrives. As far as configuration is concerned, neither the child nor the parent needs to know the other exists.

<ul>
  <li>
    <strong>Pros</strong>
    <ul>
      <li>
        Simplicity - very little configuration is required
      </li>
      <li>
        Reusability - the child can communicate with any ancestor willing to listen, regardless of distance
      </li>
    </ul>
  </li>
  <li>
    <strong>Cons</strong>
    <ul>
      <li>
        The implications of the event may not be obvious for team members
      </li>
      <li>
        Risk of unintentionally triggering code
      </li>
      <li>
        <a href="http://www.bennadel.com/blog/2725-how-scope-broadcast-interacts-with-isolate-scopes-in-angularjs.htm" target="_blank">Events can behave in unexpected ways when dealing with isolated scopes</a>
      </li>
    </ul>
  </li>
</ul>

```html
<!-- store.html -->
<div class='store'>
  <item ng-repeat='item in items'></item>
  <div class='total'>
    <span class='value'>{{ total() | currency }}</span>
    <div class="summary">{{ summary() }}</div>
  </div>
</div>

<!-- item.html -->
<div class='item'>
  <button ng-click='addToCart(item)'>+</button>
  <span class='price'>{{ item.price | currency }}</span>
  <ng-emoticons emoticons-data='item.icon'></ng-emoticons>
  <span class='name'>{{ item.name }}</span>
</div>
```

```coffeescript
angular.module('cherryTavern')

  .directive 'store', ->
    config =
      scope: { items: '=' }
      templateUrl: 'store.html'
      link: (scope) ->
        cart = []
        scope.total = -> _.sum(cart, 'price')
        scope.summary = -> CartHelper.summarize(cart)
        scope.$on 'item:addToCart', (event, item) ->
          cart.push(item)

  .directive 'item', ->
    config =
      templateUrl: 'item.html'
      link: (scope) ->
        scope.addToCart = (item) ->
          scope.$emit('item:addToCart', item)
```

<hr>

And that's all folks. Cheers! :beers:
