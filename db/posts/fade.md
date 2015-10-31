---
internal_id: fade
title: The Perfect Fade
tags: [css, transitions]
published: true
---

While often subtle, opacity transitions are one of the most useful ways to gracefully add/remove elements to a view and to call out important changes in an interface. But if you rely on this technique as often as I do, you've probably come across a problem with hidden components getting in the way of interactive elements. Consider a situation where you have a loader, positioned in the center of the screen, which you want to fade out as the underlying content fades in. Something like this:

<div class="line-through-image">
  <a href="/examples/fade/1" target="_blank"><img src="/images/examples/fade/1.gif" title="Example 1"></a>
</div>

With the following SCSS, you can achieve the effect pretty easily.

```scss
$delay: .1s;
$duration: .5s;
$ease: ease-out;

#wrapper {

  .content, .loader {
    transition: opacity $duration $ease $delay;
  }

  .content { opacity: 0; }

  &.initialized {
    .loader { opacity: 0; }
    .content { opacity: 1; }
  }
}
```

Not too bad, right? But when the time comes to click our button...

<div class="line-through-image">
  <a href="/examples/fade/2" target="_blank"><img src="/images/examples/fade/2.gif" title="Example 2"></a>
</div>

Blergh! It looks like the zero-opacity loader is blocking the underlying UI. No big deal, though, we know how to solve this problem; we'll just apply ` visibility: hidden` to our loader after initialization, causing the browser to hide the offending element and render our button pokable once again.

```scss
#wrapper {

  .content, .loader {
    transition: opacity $duration $ease $delay;
  }

  .content {
    visibility: hidden;
    opacity: 0;
  }

  &.initialized {
    .loader {
      visibility: hidden;
      opacity: 0;
    }
    .content {
      visibility: visible;
      opacity: 1;
    }
  }
}
```

And the result:

<div class="line-through-image">
  <a href="/examples/fade/3" target="_blank"><img src="/images/examples/fade/3.gif" title="Example 3"></a>
</div>

Mission accomplished, kind of! We can interact with the button, but our loader lost its fade-out transition along the way. So now what?

### The Solution

```scss
#wrapper {

  .loader {
    opacity: 1;
    visibility: visible;

    // When fading in, we don't want to apply any additional delay to the visibility transition; the element should be made visible as soon as the opacity transition begins.
    transition: visibility 0s $ease $delay,
                opacity $duration $ease $delay;
  }
  .content {
    opacity: 0;
    visibility: hidden;

    // This comes into play when we remove the initialized class and the content fades out; the switch to visibility hidden shouldn't happen until after the opacity has finished animating (opacity delay + opacity duration).
    transition: visibility 0s $ease ($delay + $duration),
                opacity $duration $ease $delay;
  }
  &.initialized {
    .loader {
      opacity: 0;
      visibility: hidden;

      // When fading out the loader, we need to override the default delay values to ensure the loader stays visible until the end of the opacity transition. This is the same idea that we applied to the .content transition above.
      transition-delay: ($delay + $duration), $delay;
    }
    .content {
      opacity: 1;
      visibility: visible;

      // When fading in the content, we need to override the default delay value to ensure that the element is visible as soon as the opacity animation starts.
      transition-delay: 0s;
    }
  }
}
```
### The Explanation

The key to our implementation lies in the `visibility` transition. While the property itself <a href="http://www.sitepoint.com/css3-transition-properties" target="_blank">can't be visually animated</a>, we _can_ leverage CSS transitions to delay the switch from `visible` to `hidden`, giving `opacity` just enough time to fade out before hiding the element. When the time comes to reverse the animation, we can use `transition-delay` to override the values we set in the default state.

It would be nice if there was a simpler way to perform this common task. It's been nearly a decade since jQuery spoiled us with its oh-so convenient `fadeOut()` behavior. That being said, a few extra lines of (S)CSS is a small price to pay for the ability to better separate our styling and our javascript.

<div class="line-through-image">
  <a href="/examples/fade/4" target="_blank"><img src="/images/examples/fade/4.gif" title="Example 4"></a>
</div>

If you wanna see the reverse animation in action, just click the example above, then type `$('#wrapper').toggleClass('initialized');` into the console.
