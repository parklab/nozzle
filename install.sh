#!/bin/bash

# minimize css and javascript
java -jar ../buildtools/nozzle/yuicompressor-2.4.2.jar -o Nozzle.R1/inst/js/nozzle.min.js Nozzle.R1/inst/js/nozzle.js
java -jar ../buildtools/nozzle/yuicompressor-2.4.2.jar -o Nozzle.R1/inst/css/nozzle.print.min.css Nozzle.R1/inst/css/nozzle.print.css
java -jar ../buildtools/nozzle/yuicompressor-2.4.2.jar -o Nozzle.R1/inst/css/nozzle.min.css Nozzle.R1/inst/css/nozzle.css

# build package install and remove
R CMD build Nozzle.R1 &&
R CMD install Nozzle.R1 &&
R CMD remove Nozzle.R1

# run examples
R CMD install Nozzle.R1
cd Examples;
#R --vanilla < demo.R;
R --vanilla < demo.R;
open reports/nozzle1.html;
cd ..;