###
D3 simple gauge chart based on radialProgress on BrightPoint Consulting, Inc. example for gauge charts in d3.
###


do($ = window.jQuery, window) ->

  # Define gauge chart class
  class D3SimpleGague

    # Default attributes
    defaults:
      # Effect duration
      duration: 1000

      # Chart value
      value: 50

      # Margins
      margin:
        top: 0
        right: 0
        bottom: 30
        left: 0

      # Manipulate classes
      showHoverClass: 'showHover'
      hideHoverClass: 'hideHover'

      # Width and height of chart
      width: 170
      height: 140

      # Circle diameter
      circle: 180
      diameter: 200

      # Primary label settings
      primaryLabelText: (d) ->
        "#{Math.round(d)}%"

      primaryLabelTextHover: ""

      # Secondary label settings
      secondaryLabelText: ""
      secondaryLabelTextHover: ""

      # Gray lines
      grayLines: 5
      spaceBetweenGrayLines: 7

      # Circle gradient color
      startColor: "#f9a535"
      stopColor:  "#f48e07"

      # Font size
      primaryFontSize:   34
      secondaryFontSize: 10

    # Static attributes (non-configurable)
    @MIN_VALUE: 0
    @MAX_VALUE: 100
    @DEG_TO_RAD: Math.PI / 90

    # Current values for drawing
    _currentArc: 0
    _currentValue: 0

    # Arc for drawing
    _arc: null
    _arcLines: null
    _arcRedPoint: null

    # Helping variables for drawing path
    _svg: null
    _myPath: null
    _rad: 72

    # Define constructor with element
    constructor: (el, options) ->
      @$el = $(el)
      @options = $.extend {}, @defaults, options, @$el.data()

      # Create arc for drawing
      @_arc         = d3.svg.arc().startAngle 0 * D3SimpleGague.DEG_TO_RAD
      @_arcLines    = d3.svg.arc()
      @_arcRedPoint = d3.svg.arc()

      # Circle!
      @options.circle /= 2

      # Start drawing
      @draw()

    # Meassure method
    meassure: () ->
      # Get margin
      margin = @options.margin

      # Update width and height
      @options.width    = @options.diameter - margin.right - margin.left - margin.top - margin.bottom
      @options.height   = @options.width
      @options.fontSize = @options.width * 0.2

      # Count int once
      outerWidth = @options.width / 2.3
      outerWidthRedPoint = @options.width / 2.339

      @_arc.outerRadius outerWidth
      @_arc.innerRadius outerWidth * 0.97

      @_arcLines.outerRadius outerWidth
      @_arcLines.innerRadius outerWidth * 0.97

      @_arcRedPoint.outerRadius outerWidthRedPoint
      @_arcRedPoint.innerRadius outerWidthRedPoint * 0.97

    # Create gradient
    createGradient: () ->
      @_svgDefs = @_svg.append 'svg:defs'
      @_gradient = @_svgDefs.append 'svg:linearGradient'
        .attr 'id', Math.random()
        .attr 'x1', '0%'
        .attr 'x2', '0%'
        .attr 'y1', '0%'
        .attr 'y2', '100%'

      # Add stops and starts
      @_gradient.append 'svg:stop'
        .attr 'offset', '0%'
        .attr 'stop-color', @options.startColor
        .attr 'stop-opacity', 1

      @_gradient.append 'svg:stop'
        .attr 'offset', '100%'
        .attr 'stop-color', @options.stopColor
        .attr 'stop-opacity', 1

    # Create background
    createBackground: () ->
      options = @options

      @_background = @_svg.append 'g'
        .attr 'class', 'component'

      @_background.append 'rect'
        .attr 'class', 'background'
        .attr 'width', @options.width
        .attr 'height', @options.height

      # Half width + font size
      half_width = options.width / 2

      # Primary label text
      primaryLabels = @_svg
        .append 'g'
        .attr 'class', 'primaryLabels'

      # Create primary and label class
      if options.primaryLabelText
        @_label = primaryLabels
          .append 'text'
          .attr 'class', "primaryLabel #{if options.primaryLabelTextHover then options.hideHoverClass else ''}"
          .attr 'y', half_width + options.primaryFontSize / 3
          .attr 'x', half_width
          .attr 'width', options.width
          .text options.primaryLabelText
          .style 'font-size', options.primaryFontSize

      if options.primaryLabelTextHover
        primaryLabels
          .append 'text'
          .attr 'class', "primaryLabel showHover"
          .attr 'y', half_width + options.primaryFontSize / 3
          .attr 'x', half_width
          .attr 'width', options.width
          .text options.primaryLabelTextHover
          .style 'font-size', options.primaryFontSize

      # Create secondary texts
      font_size  = options.primaryFontSize + 5
      secondaryLabels = @_svg
        .append 'g'
        .attr 'class', 'secondaryLabels'

      if options.secondaryLabelText
        secondaryLabels.append 'text'
          .attr 'class', "secondaryLabel #{if options.secondaryLabelTextHover then options.hideHoverClass else ''}"
          .attr 'transform', "translate(#{half_width}, #{half_width + font_size})"
          .text options.secondaryLabelText

      if options.secondaryLabelTextHover
        secondaryLabels.append 'text'
          .attr 'class', "secondaryLabelHover #{options.showHoverClass}"
          .attr 'transform', "translate(#{half_width}, #{half_width + font_size})"
          .text options.secondaryLabelTextHover


    # Draw gray lines
    drawGrayLines: () ->
      lines = @_svg
        .append 'g'
        .attr 'class', 'gray_lines'

      # If circle is half is required to not have space after last gray line
      if @options.circle == 90
        subtract = 1
      else
        subtract = 0

      # Compute line angle
      lineAngle = ((@options.circle) - ((@options.grayLines - subtract) * @options.spaceBetweenGrayLines)) / @options.grayLines

      # Half width
      half_width = @options.width / 2

      for i in [0..(@options.grayLines-1)]
        startAngle = i * lineAngle + i * @options.spaceBetweenGrayLines
        endAngle   = (i + 1) * lineAngle + i * @options.spaceBetweenGrayLines

        # Set arc
        @_arcLines.startAngle startAngle * D3SimpleGague.DEG_TO_RAD
        @_arcLines.endAngle endAngle * D3SimpleGague.DEG_TO_RAD

        lines
          .append 'path'
          .attr "transform", "translate(#{half_width}, #{half_width}), rotate(-90)"
          .attr 'fill', 'none'
          .attr 'stroke', 'lightgray'
          .attr 'stroke-width', '3'
          .attr 'stroke-linecap', 'round'
          .attr 'stroke-linejoin', 'round'
          .attr "d", @_arcLines

    # Draw colored path
    drawPath: () ->
      @_svg.append 'g'
        .attr 'class', 'arcs'

      # Create path
      half_width = @options.width / 2
      gradient_id = @_gradient.attr 'id'

      # Set end angle
      @_arc.endAngle @_currentArc

      @_path = @_svg.select(".arcs").selectAll(".arc").data([1])
      @_path.enter()
        .append "path"
        .attr "class","arc"
        .attr "transform", "translate(#{half_width}, #{half_width}), rotate(-90)"
        .attr 'fill', 'none'
        .attr 'stroke', "url(##{gradient_id})"
        .attr 'stroke-width', '12'
        .attr 'stroke-linecap', 'round'
        .attr 'stroke-linejoin', 'round'
        .attr "d", @_arc

    # Drawing method
    draw: () ->
      that = @

      # Get svg element
      @_svg = d3.select(@$el.get(0)).selectAll('svg').data([1])

      # Create radial svg input
      @_enter = @_svg.enter()
        .append('svg')
        .attr('class', 'radial-svg d3SimpleGauge')

      # Meassure values
      @meassure()

      # Set values for svg
      @_svg.attr 'width', @options.width
        .attr 'height', @options.height

      # Create gradient
      @createGradient()

      # Create background
      @createBackground()

      # Draw lines
      if Number.parseInt(@options.grayLines)
        @drawGrayLines()

      # Draw path
      @drawPath()

      # Draw red circle

      # Start animation
      ratio    = @options.value / 100
      endAngle = Math.min(@options.circle*ratio, @options.circle)
      endAngle = endAngle * D3SimpleGague.DEG_TO_RAD
      @_path.exit().transition().duration(500).attr('x', 1000).remove()
      @_path.datum(endAngle)
      @_path.transition()
        .duration(@options.duration)
        .attrTween 'd', (a) ->
          that.arcTween a

      # Text animation
      if @options.primaryLabelText && @options.primaryLabelText.call && @options.primaryLabelText.apply
        @_label.datum Math.round(ratio * 100)
        @_label.transition()
          .duration @options.duration
          .tween 'text', (a) ->
            that.arcLabelTween a

    # Tween circle animation
    arcTween: (a) ->
      that = @
      i = d3.interpolate(that._currentArc, a)
      (t) ->
        that._currentArc = i(t)
        that._arc.endAngle(i(t))()


    # Label text animation
    arcLabelTween: (a) ->
      that = @
      i = d3.interpolate(that._currentValue, a)
      _currentValue = i(0)

      (t) ->
        that._currentValue = i(t)
        this.textContent = that.options.primaryLabelText(i(t))

  # Define jQuery plugin
  $.fn.d3SimpleGauge = (option, args...) ->
    @each ->
      $this = $(this)
      data  = $this.data('d3SimpleGauge')

      if !data
        $this.data 'd3SimpleGauge', (data = new D3SimpleGague(this, option))
      if typeof option == 'string'
        data[option].apply(data, args)
