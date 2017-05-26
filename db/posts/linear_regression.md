---
public_id: linear_regression
title: "Linear Regression w/ Gradient Descent <span class='series'>(Machine Learning for Mere Mortals)</span>"
tags:
  - machine_learning
  - regression
  - gradient_descent
published: true
---

<link rel="stylesheet" type="text/css" href="/vendor/katex-0.7.1/katex.min.css">
<script src="/vendor/katex-0.7.1/katex.min.js"></script>
<script src="/vendor/plotly-1.27.0/plotly-basic.min.js"></script>

Welcome to the second episode of <a href="/blog?tag=machine_learning">Machine Learning for Mere Mortals</a>! Previously, we talked about <a target="_blank" href="/blog/naive_bayes"> Naive Bayes</a>, which we refer to as a __classification algorithm__; because it attempts to classify inputs into discrete categories. Today we're going implement a __regression algorithm__ (specifically, linear regression) to predict continuous numeric values.

You probably remember calculating the "line of best fit" back in middle school. Given a set of data points – let's say:

```javascript
const points = [
  { x: 0, y: 3.3 },
  { x: 1, y: 4.4 },
  { x: 2, y: 6.5 },
  { x: 3, y: 7.9 },
  { x: 4, y: 9.9 },
];
```

We would calculate the __slope__, <span class="katex-wrapper inline">m</span>, and __y-intercept__, <span class="katex-wrapper inline">b</span>, of a function that took the shape <span class="katex-wrapper inline">y = b + mx</span>.

<figure>
  <div class="chart-wrapper">
    <div class="chart" id="line-of-best-fit-chart"></div>
  </div>
</figure>

The formula that allowed us to make those forecasts looked something like this:


<figure class="katex-figure">
  <div class="katex-wrapper">
    m = \frac{n\sum{xy} - (\sum{x})(\sum{y})}{n\sum{x^2} - (\sum{x})^2}
  </div>
</figure>

<figure class="katex-figure">
  <div class="katex-wrapper">
    b = \frac{\sum{y} - m(\sum{x})}{n}
  </div>
</figure>

<figure>
  <div class="chart-wrapper">
    <div class="chart" id="simple-gradient-descent-chart"></div>
  </div>
</figure>

Let's revisit our UFO sightings data set and see if we can arrive at a similar conclusion using gradient descent. To be

<figure class="katex-figure">
  <figcaption>
    Let's start by defining our <strong>hypothesis</strong>, <div class="katex-wrapper inline">h_\theta(x_i)</div>, which takes the familiar shape of <div class="katex-wrapper inline">y = b + mx</div>.
  </figcaption>
  <div class="katex-wrapper">
    h_\theta(x_i) = \theta_0 + \theta_1 x_i
  </div>
</figure>

<figure class="katex-figure">
  <figcaption>
    And our <strong>cost function</strong>, <div class="katex-wrapper inline">J(\theta_0, \theta_1)</div>, which is the sum of differences between our predicted outcomes – i.e. our hypothesis' results – and the actual values of <div class="katex-wrapper inline">y_i</div>, all divided by <div class="katex-wrapper inline">2m</div>, where <div class="katex-wrapper inline">m</div> is the number of points in our data set.
  </figcaption>
  <div class="katex-wrapper">
    J(\theta_0, \theta_1) = \frac{1}{2m} \sum_{i=1}^m (h_\theta(x_i)-y_i)
  </div>
</figure>

<figure class="katex-figure">
  <figcaption>
    In order to measure the error of each <a target="_blank" href="https://www.youtube.com/watch?v=SbfRDBmyAMI">use the chain rule to calculate partial derivatives</a> for <div class="katex-wrapper inline">\theta_0</div> and <div class="katex-wrapper inline">\theta_1</div>.
  </figcaption>
  <div class="katex-wrapper">
    \frac{\partial}{\partial\theta_0}h_\theta(x_i)=1, \ \frac{\partial}{\partial\theta_1}h_\theta(x_i) = x_i
  </div>
</figure>

I won't try to explain the math used to simplify  <a target="_blank" href="https://math.stackexchange.com/a/1695446">Christian Sykes</a>.

<figure class="katex-figure">
  <div class="katex-wrapper">
    \frac{\partial}{\partial\theta_j} J(\theta_0, \theta_1) = \frac{\partial}{\partial\theta_j}\frac{1}{2m} \sum_{i=1}^m (h_\theta(x_i)-y_i)^2
  </div>
</figure>

<figure class="katex-figure">
  <div class="katex-wrapper">
  ...
  </div>
</figure>

<figure class="katex-figure">
  <div class="katex-wrapper">
...
  </div>
</figure>

<figure class="katex-figure">
  <div class="katex-wrapper">
...
  </div>
</figure>

<figure class="katex-figure">
  <div class="katex-wrapper">
...
  </div>
</figure>

<figure class="katex-figure">
  <div class="katex-wrapper">
...
  </div>
</figure>

<figure>
  <div class="chart-wrapper">
    <div class="chart" id="ufo-sightings-chart"></div>
  </div>
</figure>

In this post, we applied __mini-batch gradient descent__, which means we
<a target="_blank" href="http://sebastianruder.com/optimizing-gradient-descent/index.html#batchgradientdescent">Sebastian Ruder</a> does an incredible job of

<style>
  #simple-gradient-descent-chart .legend { transform:  translate(75px, 9px) !important; }
  #uto-sightings-chart .legend { transform: translate(80px, 12px) !important; }
  #ufo-sightings-chart .g-xtitle { transform: translate(0px, -8px) !important; }
  #ufo-sightings-chart .g-ytitle { transform: translate(-16px, 0px) !important; }
</style>

<script>
  setTimeout(function() {

    /***********************************************/
    /* Render Katex */
    /***********************************************/

    $('.post').find('.katex-wrapper').each(function(i, el) {
      katex.render($(el).html(), el);
    });


    /***********************************************/
    /* Defaults */
    /***********************************************/

    var defaultConfig = window.cherryPickings.getDefaultPlotlyConfig();
    var defaultLayout = window.cherryPickings.getDefaultPlotlyLayout();
    var charts = [];



    /***********************************************/
    /* Line of Best Fit */
    /***********************************************/

    var lineOfBestFitChartEl = document.getElementById('line-of-best-fit-chart');

    var lineOfBestFitScatterTrace = {
      name: 'Actual Data Points',
      mode: 'markers',
      type: 'scatter',
      x: [0,1,2,3,4],
      y: [3.3, 4.4, 6.5, 7.9, 9.9],
      marker: {
        color: '#1F77B4',
      }
    };

    var lineOfBestFitRegressionTrace = {
      name: 'Prediction (y = 3.18 + 1.64x)',
      mode: 'lines',
      type: 'scatter',
      line: {
        color: 'rgba(255, 127, 14, 1)'
      },
      x: [0, 4],
      y: [3.18, 9.74],
    };

    var lineOfBestFitLayout = Object.assign({}, defaultLayout, {
      margin: { l: 30, r: 5, t: 30, b: 40, pad: 3 },
      xaxis: {
        fixedrange: true,
        nticks: 5,
        tickmode: 'auto',
        zeroline: false,
        showline: false,
      }
    });

    charts.push(lineOfBestFitChartEl);
    Plotly.plot(lineOfBestFitChartEl, [lineOfBestFitScatterTrace, lineOfBestFitRegressionTrace], lineOfBestFitLayout, defaultConfig);

    /***********************************************/
    /* Simple Gradient Descent */
    /***********************************************/

    var simpleGDChartEl = document.getElementById('simple-gradient-descent-chart');

    var simpleGDScatterTrace = {
      name: 'Actual Data',
      mode: 'markers',
      type: 'scatter',
      x: [0,1,2,3,4],
      y: [3.3, 4.4, 6.5, 7.9, 9.9],
      marker: {
        color: '#1F77B4',
      }
    };

    var simpleGDIterationResults = [
      { iteration: 0, t0: 0, t1: 0, color: 'rgba(255, 127, 14, .1)', error: 232.92 },
      { iteration: 10, t0: 0.28, t1: 0.69, color: 'rgba(255, 127, 14, .30)', error: 121.70 },
      { iteration: 50, t0: 0.85, t1: 1.94 , color: 'rgba(255, 127, 14, .45)', error: 14.67 },
      { iteration: 100, t0: 1.13, t1: 2.25, color: 'rgba(255, 127, 14, .60)', error: 6.51 },
      { iteration: 1000, t0: 2.56, t1: 1.84, color: 'rgba(255, 127, 14, .75)', error: 0.64 },
      { iteration: 5000, t0: 3.05, t1: 1.67, color: 'rgba(255, 127, 14, 1)', error: 0.23 },
    ];

    var simpleGDRegressionTraces = [], result;
    for (var i = 0; i < simpleGDIterationResults.length; i++) {
      result = simpleGDIterationResults[i];
      simpleGDRegressionTraces.push({
        name: 'Iteration ' + result.iteration,
        mode: 'lines',
        type: 'scatter',
        line: {
          color: result.color,
        },
        x: [0, 4],
        y: [result.t0, result.t0 + result.t1 * 4],
      });
    }

    var simpleGDLayout = Object.assign({}, defaultLayout, {
      margin: { l: 30, r: 5, t: 60, b: 40, pad: 3 },
      xaxis: {
        fixedrange: true,
        nticks: 5,
        tickmode: 'auto',
        zeroline: false,
        showline: false,
      }
    })

    charts.push(simpleGDChartEl);
    Plotly.plot(simpleGDChartEl, simpleGDRegressionTraces.concat(simpleGDScatterTrace), simpleGDLayout, defaultConfig);


    /***********************************************/
    /* UFO Sightings */
    /***********************************************/

    var ufoChartEl = document.getElementById('ufo-sightings-chart');

    var ufoScatterTrace = {
      name: 'Actual',
      mode: 'markers',
      type: 'scatter',
      x: [1994,1995,1996,1997,1998,1999,2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016],
      y: [495,1468,1007,1437,2013,3151,3083,3522,3675,4412,4731,4506,4153,4722,5279,4969,4752,5593,8072,7771,8631,6850,5561],
    };

    var ufoRegressionTrace = {
      name: 'Predicted',
      mode: 'lines',
      type: 'scatter',
      x: [1994,1995,1996,1997,1998,1999,2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016],
      y: [1098.6054646027042,1393.9288106419845,1689.2521566811483,1984.5755027204286,2279.8988487595925,2575.222194798873,2870.545540838153,3165.868886877317,3461.1922329165973,3756.515578955761,4051.8389249950415,4347.162271034205,4642.485617073486,4937.8089631126495,5233.13230915193,5528.455655191094,5823.779001230374,6119.102347269538,6414.425693308818,6709.749039347982,7005.072385387262,7300.395731426426,7595.7190774657065],
    };

    var ufoLayout = Object.assign({}, defaultLayout, {
      xaxis: {
        title: 'Year',
        fixedrange: true,
      },
      yaxis: {
        title: 'UFO Sightings',
        fixedrange: true,
      },
      margin: { l: 78, r: 10, t: 10, b: 60, pad: 8 },
    });

    charts.push(ufoChartEl);
    Plotly.plot(ufoChartEl, [ufoScatterTrace, ufoRegressionTrace], ufoLayout, defaultConfig);


    /***********************************************/
    /* Resizing */
    /***********************************************/

    function resizeCharts() {
      charts.forEach((chartEl) => {
        Plotly.relayout(chartEl, {
          width: $('.post .body').width() - 40,
          height: 350
        });
      });
    }

    resizeCharts();
    $(window).on('resize', resizeCharts);


    /***********************************************/
    /* Teardown */
    /***********************************************/

    $(window).on('$stateChangeStart', function() {
      charts.forEach((chartEl) => Plotly.purge(chartEl));
      $(window).off('resize', resizeCharts)
    });
  });
</script>
