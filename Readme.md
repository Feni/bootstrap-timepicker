#Timepicker
A tiny widget to pick the time. This is a simplified version of [bootstrap-timepicker](http://jdewit.github.io/bootstrap-timepicker/) without the bootstrap dependency and with a more minimal feature-set. 

###Why?
Because
    <input type="datetime"/>
isn't implemented by most browsers yet. 

###What did you change?
  - Removed dropdown and modal bootstrap dependencies.
  - Removed the main text-input. 
  - Removed 24 hour format. 
  - Removed seconds field. 
  - Removed some of the styling. 
  - Replaced boostrap icons with CSS arrows (unicode is also an option)
  - Moved templating code to HTML from JS
  - Changed LESS to SASS
  - Added CoffeeScript

The new css, js and html code is just 4.1 KB gzipped and minified. 
The only dependency is JQuery. 

###License
MIT License. Do whatever you want with it. 