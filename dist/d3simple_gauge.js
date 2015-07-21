/*
D3 simple gauge chart based on radialProgress on BrightPoint Consulting, Inc. example for gauge charts in d3.
 */

(function() {
  var slice = [].slice;

  (function($, window) {
    var D3SimpleGague;
    D3SimpleGague = (function() {
      D3SimpleGague.prototype.defaults = {
        duration: 1000,
        value: 50,
        margin: {
          top: 0,
          right: 0,
          bottom: 30,
          left: 0
        },
        showHoverClass: 'showHover',
        hideHoverClass: 'hideHover',
        width: 170,
        height: 140,
        circle: 180,
        diameter: 200,
        primaryLabelText: function(d) {
          return (Math.round(d)) + "%";
        },
        primaryLabelTextHover: "",
        secondaryLabelText: "",
        secondaryLabelTextHover: "",
        grayLines: 5,
        spaceBetweenGrayLines: 7,
        startColor: "#f9a535",
        stopColor: "#f48e07",
        primaryFontSize: 34,
        secondaryFontSize: 10
      };

      D3SimpleGague.MIN_VALUE = 0;

      D3SimpleGague.MAX_VALUE = 100;

      D3SimpleGague.DEG_TO_RAD = Math.PI / 90;

      D3SimpleGague.prototype._currentArc = 0;

      D3SimpleGague.prototype._currentValue = 0;

      D3SimpleGague.prototype._arc = null;

      D3SimpleGague.prototype._arcLines = null;

      D3SimpleGague.prototype._arcRedPoint = null;

      D3SimpleGague.prototype._svg = null;

      D3SimpleGague.prototype._myPath = null;

      D3SimpleGague.prototype._rad = 72;

      function D3SimpleGague(el, options) {
        this.$el = $(el);
        this.options = $.extend({}, this.defaults, options, this.$el.data());
        this._arc = d3.svg.arc().startAngle(0 * D3SimpleGague.DEG_TO_RAD);
        this._arcLines = d3.svg.arc();
        this._arcRedPoint = d3.svg.arc();
        this.options.circle /= 2;
        this.draw();
      }

      D3SimpleGague.prototype.meassure = function() {
        var margin, outerWidth, outerWidthRedPoint;
        margin = this.options.margin;
        this.options.width = this.options.diameter - margin.right - margin.left - margin.top - margin.bottom;
        this.options.height = this.options.width;
        this.options.fontSize = this.options.width * 0.2;
        outerWidth = this.options.width / 2.3;
        outerWidthRedPoint = this.options.width / 2.339;
        this._arc.outerRadius(outerWidth);
        this._arc.innerRadius(outerWidth * 0.97);
        this._arcLines.outerRadius(outerWidth);
        this._arcLines.innerRadius(outerWidth * 0.97);
        this._arcRedPoint.outerRadius(outerWidthRedPoint);
        return this._arcRedPoint.innerRadius(outerWidthRedPoint * 0.97);
      };

      D3SimpleGague.prototype.createGradient = function() {
        this._svgDefs = this._svg.append('svg:defs');
        this._gradient = this._svgDefs.append('svg:linearGradient').attr('id', Math.random()).attr('x1', '0%').attr('x2', '0%').attr('y1', '0%').attr('y2', '100%');
        this._gradient.append('svg:stop').attr('offset', '0%').attr('stop-color', this.options.startColor).attr('stop-opacity', 1);
        return this._gradient.append('svg:stop').attr('offset', '100%').attr('stop-color', this.options.stopColor).attr('stop-opacity', 1);
      };

      D3SimpleGague.prototype.createBackground = function() {
        var font_size, half_width, options, primaryLabels, secondaryLabels;
        options = this.options;
        this._background = this._svg.append('g').attr('class', 'component');
        this._background.append('rect').attr('class', 'background').attr('width', this.options.width).attr('height', this.options.height);
        half_width = options.width / 2;
        primaryLabels = this._svg.append('g').attr('class', 'primaryLabels');
        if (options.primaryLabelText) {
          this._label = primaryLabels.append('text').attr('class', "primaryLabel " + (options.primaryLabelTextHover ? options.hideHoverClass : '')).attr('y', half_width + options.primaryFontSize / 3).attr('x', half_width).attr('width', options.width).text(options.primaryLabelText).style('font-size', options.primaryFontSize);
        }
        if (options.primaryLabelTextHover) {
          primaryLabels.append('text').attr('class', "primaryLabel showHover").attr('y', half_width + options.primaryFontSize / 3).attr('x', half_width).attr('width', options.width).text(options.primaryLabelTextHover).style('font-size', options.primaryFontSize);
        }
        font_size = options.primaryFontSize + 5;
        secondaryLabels = this._svg.append('g').attr('class', 'secondaryLabels');
        if (options.secondaryLabelText) {
          secondaryLabels.append('text').attr('class', "secondaryLabel " + (options.secondaryLabelTextHover ? options.hideHoverClass : '')).attr('transform', "translate(" + half_width + ", " + (half_width + font_size) + ")").text(options.secondaryLabelText);
        }
        if (options.secondaryLabelTextHover) {
          return secondaryLabels.append('text').attr('class', "secondaryLabelHover " + options.showHoverClass).attr('transform', "translate(" + half_width + ", " + (half_width + font_size) + ")").text(options.secondaryLabelTextHover);
        }
      };

      D3SimpleGague.prototype.drawGrayLines = function() {
        var endAngle, half_width, i, j, lineAngle, lines, ref, results, startAngle, subtract;
        lines = this._svg.append('g').attr('class', 'gray_lines');
        if (this.options.circle === 90) {
          subtract = 1;
        } else {
          subtract = 0;
        }
        lineAngle = (this.options.circle - ((this.options.grayLines - subtract) * this.options.spaceBetweenGrayLines)) / this.options.grayLines;
        half_width = this.options.width / 2;
        results = [];
        for (i = j = 0, ref = this.options.grayLines - 1; 0 <= ref ? j <= ref : j >= ref; i = 0 <= ref ? ++j : --j) {
          startAngle = i * lineAngle + i * this.options.spaceBetweenGrayLines;
          endAngle = (i + 1) * lineAngle + i * this.options.spaceBetweenGrayLines;
          this._arcLines.startAngle(startAngle * D3SimpleGague.DEG_TO_RAD);
          this._arcLines.endAngle(endAngle * D3SimpleGague.DEG_TO_RAD);
          results.push(lines.append('path').attr("transform", "translate(" + half_width + ", " + half_width + "), rotate(-90)").attr('fill', 'none').attr('stroke', 'lightgray').attr('stroke-width', '3').attr('stroke-linecap', 'round').attr('stroke-linejoin', 'round').attr("d", this._arcLines));
        }
        return results;
      };

      D3SimpleGague.prototype.drawPath = function() {
        var gradient_id, half_width;
        this._svg.append('g').attr('class', 'arcs');
        half_width = this.options.width / 2;
        gradient_id = this._gradient.attr('id');
        this._arc.endAngle(this._currentArc);
        this._path = this._svg.select(".arcs").selectAll(".arc").data([1]);
        return this._path.enter().append("path").attr("class", "arc").attr("transform", "translate(" + half_width + ", " + half_width + "), rotate(-90)").attr('fill', 'none').attr('stroke', "url(#" + gradient_id + ")").attr('stroke-width', '12').attr('stroke-linecap', 'round').attr('stroke-linejoin', 'round').attr("d", this._arc);
      };

      D3SimpleGague.prototype.draw = function() {
        var endAngle, ratio, that;
        that = this;
        this._svg = d3.select(this.$el.get(0)).selectAll('svg').data([1]);
        this._enter = this._svg.enter().append('svg').attr('class', 'radial-svg d3SimpleGauge');
        this.meassure();
        this._svg.attr('width', this.options.width).attr('height', this.options.height);
        this.createGradient();
        this.createBackground();
        if (Number.parseInt(this.options.grayLines)) {
          this.drawGrayLines();
        }
        this.drawPath();
        ratio = this.options.value / 100;
        endAngle = Math.min(this.options.circle * ratio, this.options.circle);
        endAngle = endAngle * D3SimpleGague.DEG_TO_RAD;
        this._path.exit().transition().duration(500).attr('x', 1000).remove();
        this._path.datum(endAngle);
        this._path.transition().duration(this.options.duration).attrTween('d', function(a) {
          return that.arcTween(a);
        });
        if (this.options.primaryLabelText && this.options.primaryLabelText.call && this.options.primaryLabelText.apply) {
          this._label.datum(Math.round(ratio * 100));
          return this._label.transition().duration(this.options.duration).tween('text', function(a) {
            return that.arcLabelTween(a);
          });
        }
      };

      D3SimpleGague.prototype.arcTween = function(a) {
        var i, that;
        that = this;
        i = d3.interpolate(that._currentArc, a);
        return function(t) {
          that._currentArc = i(t);
          return that._arc.endAngle(i(t))();
        };
      };

      D3SimpleGague.prototype.arcLabelTween = function(a) {
        var _currentValue, i, that;
        that = this;
        i = d3.interpolate(that._currentValue, a);
        _currentValue = i(0);
        return function(t) {
          that._currentValue = i(t);
          return this.textContent = that.options.primaryLabelText(i(t));
        };
      };

      return D3SimpleGague;

    })();
    return $.fn.d3SimpleGauge = function() {
      var args, option;
      option = arguments[0], args = 2 <= arguments.length ? slice.call(arguments, 1) : [];
      return this.each(function() {
        var $this, data;
        $this = $(this);
        data = $this.data('d3SimpleGauge');
        if (!data) {
          $this.data('d3SimpleGauge', (data = new D3SimpleGague(this, option)));
        }
        if (typeof option === 'string') {
          return data[option].apply(data, args);
        }
      });
    };
  })(window.jQuery, window);

}).call(this);
