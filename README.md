D3 Simple Gauge Charts
======================

Simple Gauge charts based on D3 and JQuery, with highly configurable
options.

Examples
--------------

![]

or example on **jsfiddle** https://jsfiddle.net/z4mao901/4/ !

Usage
--------------

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

Customization
--------------

Each parameter can be passed via data-\* attributes or directly in javascript options. Imagine you want to change percents into days.

```javascript
$(document).ready(function() {
   $('.chart').d3SimpleGauge({
      value: 30, // Percentage
      primaryLabelText: function(d) {
          // Reverse countdown for days
          return Math.round(50 - (50 * d) / 100) + " days"; 
      }
    });
});
```

Charts are drawed via SVG, you can modify some effects via CSS like smooth hover opacity change.

### Attributes

| Attribute               | Default value | Explain                                              |
|-------------------------|---------------|------------------------------------------------------|
| duration                | 1000          | Effect duration                                      |
| value                   | 50            | Chart value in %                                     |
| showHoverClass          | showHover     | Class for show on hover                              |
| hideHoverClass          | hideHover     | Class for hide on hover                              |
| width                   | 170           | Chart width                                          |
| height                  | 140           | Chart height                                         |
| diameter                | 200           | Circle diameter                                      |
| margin                  | {}            | Margins (top, right, bottom, left)                   |
| circle                  | 180           | Circle radius (half / full ... - examples)           |
| primaryLabelText        | fct(d) %      | Label text (function with percent attribute or text) |
| primaryLabelTextHover   | ""            | Label text on hover                                  |
| primaryFontSize         | 34            | Primary font size                                    |
| secondaryLabelText      | ""            | Secondary label (yellow label)                       |
| secondaryLabelTextHover | ""            | Secondary label on hover                             |
| secondaryFontSize       | 10            | Secondary font size                                  |
| grayLines               | 5             | Number of gray lines                                 |
| spaceBetweenGrayLines   | 7             | Space between gray lines                             |
| startColor              | #f9a535       | Start gradient color                                 |
| stopColor               | #f48e07       | Stop gradient color                                  |

Licence
--------------
MIT

This library is based on Radial Progress library from BrightPoint Inc. (under MIT license) http://www.brightpointinc.com/clients/brightpointinc.com/library/radialProgress/download.html

Pull request
--------------

Fork, create new branch, feel free to hack :-)


  []: https://raw.githubusercontent.com/ChattyCrow/d3_simple_gauge_charts/master/example.png
