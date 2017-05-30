---
public_id: linear_regression
title: "Linear Regression w/ Gradient Descent <span class='series'>(Machine Learning for Mere Mortals)</span>"
tags:
  - machine_learning
  - regression
  - gradient_descent
published: true
---

<script src="/vendor/plotly-1.27.0/plotly-basic.min.js"></script>

Welcome to the second episode of <a href="/blog?tag=machine_learning">Machine Learning for Mere Mortals</a>! Previously, we talked about <a target="_blank" href="/blog/naive_bayes">Naive Bayes</a>, which we refer to as a __classification algorithm__; because it attempts to classify inputs into discrete categories. Today we're going implement a __regression algorithm__ (specifically, linear regression) to predict continuous numeric values.

You probably remember calculating the "line of best fit" back in high school. If we were given a set of data points – let's say:

<table class="data-table two-column equal-column-widths align-center">
  <thead>
    <tr>
      <th>x</th>
      <th>y</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>0</td>
      <td>3.3</td>
    </tr>
    <tr>
      <td>1</td>
      <td>4.4</td>
    </tr>
        <tr>
      <td>2</td>
      <td>6.5</td>
    </tr>
        <tr>
      <td>3</td>
      <td>7.9</td>
    </tr>
        <tr>
      <td>4</td>
      <td>9.9</td>
    </tr>
  </tbody>
</table>

We would use the formulae below to calculate a __y-intercept__, <span class="cp-katex inline">\theta_0</span>, and __slope__, <span class="cp-katex inline">\theta_1</span>, for a function that takes the shape <span class="cp-katex inline">y = \theta_0 + \theta_{1}x</span>. Then, for any value of <span class="cp-katex inline">x</span>, we could use our line of best fit to estimate the outcome variable, <span class="cp-katex inline">y</span>.

<figure class="katex-figure">
  <figcaption>Given <span class="cp-katex inline">n</span> is the number of points in the dataset:</figcaption>
  <div class=cp-katex>
    \theta_1 = \frac{n\sum{x_{i}y_i} - (\sum{x_i})(\sum{y_i})}{n\sum{x_{i}^2} - (\sum{x_i})^2}
  </div>
</figure>

<figure class="katex-figure">
  <div class="cp-katex">
    \theta_0 = \frac{\sum{y_i} - \theta_1\sum{x_i}}{n}
  </div>
</figure>

When we plug in the values from our tiny sample dataset, we end up with a regression of <span class="cp-katex inline">y = 3.24 + 1.64x</span>. Or, in graphical form:

<figure>
  <div class="chart-wrapper">
    <div class="chart" id="line-of-best-fit-chart"></div>
  </div>
</figure>

It's important to note that (without any transformations) the line of best fit only works when the data actually conforms to a linear trend. Assuming the requirement is met, we can get a lot of mileage from analytic approaches like this one.

Now, you might be wondering how machine learning ties into all of this, considering that we could calculate a regression line with a well-sharpened pencil. The short answer is that <a target="_blank" href="https://en.wikipedia.org/wiki/Closed-form_expression">closed-form</a> expressions <a target="_blank" href="https://stats.stackexchange.com/a/23132">don't always perform well when dealing with large, multivariate datasets</a>; we'd prefer a solution that's easier to parallelize and less vulnerable to memory limitations. Furthermore, real-world problems often can't be solved by closed-form solutions, and it would be nice to have a more generic approach that can be applied to a wider range of scenarios.

This is where we introduce one of the fundamental concepts of machine learning: __gradient descent__. <a target="_blank" href="https://hackernoon.com/life-is-gradient-descent-880c60ac1be8">Rohan Kshirsagar</a> describes it as:

> …a really beautiful algorithm that helps find the optimal solution to a function, and forms the foundations of how we train intelligent systems today. It’s based off a very simple idea — rather than figuring out the best solution to a problem immediately, it guesses an initial solution and steps it in a direction that’s closer to a better solution. The algorithm is to repeat this procedure, until the solution is good enough.



The driving force behind gradient descent is the __cost function__. The cost function is a

Today we're going to be using <a target="_blank" href="https://en.wikipedia.org/wiki/Mean_squared_error">mean squared error</a>

Let's start by defining a __hypothesis__, <span class="cp-katex inline">h_\theta(x_i)</span>, which is the function that _predicts_ the value of <span class="cp-katex inline">y</span>. In this example, we're assuming that the data adheres to a linear pattern. Our hypothesis should look familiar; it's simply the function of a straight line:

<figure class="katex-figure">
   <div class="cp-katex">
    h_\theta(x_i) = \theta_0 + \theta_{1}x_i
  </div>
</figure>

Next, we'll need to come up with a __cost function__, <span class="cp-katex inline">J(\theta_0, \theta_1)</span>, which is . In this case, we'll

 is the sum of differences between our predicted outcomes – i.e. our hypothesis' results – and the actual values of <span class="cp-katex inline">y_i</span>, all divided by <span class="cp-katex inline">2m</span>, where <span class="cp-katex inline">m</span> is the number of points in our dataset.

<figure class="katex-figure">
  <div class="cp-katex">
    J(\theta) = \frac{1}{2m} \sum_{i=1}^m{(h_\theta(x_i)-y_i)^2}
  </div>
</figure>

In order to measure the error of each <a target="_blank" href="https://www.youtube.com/watch?v=SbfRDBmyAMI">use the chain rule to calculate partial derivatives</a> for <div class="cp-katex inline">\theta_0</div> and <div class="cp-katex inline">\theta_1</div>.

<figure class="katex-figure">
  <div class="cp-katex">
    \frac{\partial}{\partial\theta_0}h_\theta(x_i)=1, \ \frac{\partial}{\partial\theta_1}h_\theta(x_i) = x_i
  </div>
</figure>

I won't try to explain the math used to simplify  <a target="_blank" href="https://math.stackexchange.com/a/1695446">Christian Sykes</a>.

<figure class="katex-figure">
  <div class="cp-katex">
    \frac{\partial}{\partial\theta_j} J(\theta_0, \theta_1) = \frac{\partial}{\partial\theta_j}\frac{1}{2m} \sum_{i=1}^m (h_\theta(x_i)-y_i)^2
  </div>
</figure>

<figure>
  <div class="cp-katex">
    <div class="chart" id="simple-gradient-descent-chart"></div>
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
      name: 'Actual Data',
      mode: 'markers',
      type: 'scatter',
      x: [0,1,2,3,4],
      y: [3.3, 4.4, 6.5, 7.9, 9.9],
      marker: {
        color: '#1F77B4',
      }
    };

    var lineOfBestFitRegressionTrace = {
      name: 'Line of Best Fit: y = 3.24 + 1.64x',
      mode: 'lines',
      type: 'scatter',
      line: {
        color: 'rgba(255, 127, 14, 1)'
      },
      x: [0, 4],
      y: [3.24, 9.8],
    };

    var lineOfBestFitLayout = Object.assign({}, defaultLayout, {
      margin: { l: 30, r: 5, t: 25, b: 40, pad: 3 },
      xaxis: {
        fixedrange: true,
        nticks: 5,
        tickmode: 'auto',
        zeroline: false,
        showline: false,
      }
    });

    charts.push(lineOfBestFitChartEl);
    Plotly.plot(lineOfBestFitChartEl, [lineOfBestFitRegressionTrace, lineOfBestFitScatterTrace], lineOfBestFitLayout, defaultConfig);

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
      { iteration: 0, t0: 0, t1: 0, color: 'rgba(255, 127, 14, .1)', error: 239.64 },
      { iteration: 10, t0: 0.29, t1: 0.70, color: 'rgba(255, 127, 14, .30)', error: 125.69 },
      { iteration: 50, t0: 0.88, t1: 1.96 , color: 'rgba(255, 127, 14, .45)', error: 15.93 },
      { iteration: 100, t0: 1.17, t1: 2.28, color: 'rgba(255, 127, 14, .60)', error: 7.44 },
      { iteration: 1000, t0: 2.70, t1: 1.83, color: 'rgba(255, 127, 14, .75)', error: 0.67 },
      { iteration: 5000, t0: 3.23, t1: 1.64, color: 'rgba(255, 127, 14, 1)', error: 0.19 },
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
