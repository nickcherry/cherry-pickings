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
        pad: 3 # distance between axes and labels
      paper_bgcolor: 'transparent',
      plot_bgcolor: 'transparent'
      showlegend: true
      xaxis:
        fixedrange: true
      yaxis:
        fixedrange: true
