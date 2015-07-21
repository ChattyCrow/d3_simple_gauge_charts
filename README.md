D3 Simple Gauge Charts
======================

Simple Gauge charts based on D3 and JQuery, with highly configurable
options.

Visual example
--------------

![]

### Usage

1. Add libraries D3, JQuery and d3 simple gauge chart (both js & css) to your project
2. Create div for chart (only required variable is value)

```html
<div class='chart' data-value=30></div>
```

3. Run

```javascript
$(document).ready(function() {
   $('.chart').d3SimpleGauge();
});
```

### Customization

Each parameter can be passed via data-\* attributes or directly in javascript options. Imagine you want to change percents into days.

```javascript
$(document).ready(function() {
   $('.chart').d3SimpleGauge({
      value: 30, // Percentage
      primaryLabelText: function(d) {
          // 50 days is 100% ... 30% is (50 * 30) / 100
          return Math.round((50 * 30) / 100));
      }
    });
});
```

  []: https://raw.githubusercontent.com/ChattyCrow/d3_simple_gauge_charts/master/example.png
