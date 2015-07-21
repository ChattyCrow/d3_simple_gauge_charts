#!/bin/bash
echo "Compiling and minifying coffee script ..."
coffee -p src/scripts/d3simple_gauge.js.coffee > dist/d3simple_gauge.js
minify dist/d3simple_gauge.js --output dist/d3simple_gauge.min.js

echo "Compiling and minifying styles ..."
sass src/stylesheets/d3simple_gauge.css.scss > dist/d3simple_gauge.css
minify dist/d3simple_gauge.css --output dist/d3simple_gauge.min.css
