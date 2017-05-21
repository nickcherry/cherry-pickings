_.extend (window.cherryPickings ||= {}),

  # https://github.com/ropensci/plotly/issues/284
  getDefaultPlotlyConfig: ->
    _.assign {},
      autosizable: false
      displaylogo: false
      displayModeBar: false
      doubleClick: false
      editable: false
      scrollZoom: false
      showTips: false
      staticPlot: false
      showLink: false

  getDefaultPlotlyLayout: ->
    _.assign {},
      autosize: true
      font:
        family: 'MuseoSans, sans-serif'
      hovermode: false
      legend:
        x: 0
        y: 1
      margin:
        l: 40
        r: 30
        b: 30
        t: 30
        pad: 5 # Sets the amount of padding (in px) between the plotting area and the axis lines
      paper_bgcolor: 'transparent',
      plot_bgcolor: 'transparent'
      showlegend: true
      xaxis:
        fixedrange: true
        zeroline: false
        showline: false
      yaxis:
        fixedrange: true
        zeroline: false
        showline: false
