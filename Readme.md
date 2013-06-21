#Timepicker
A tiny widget to pick the time. This is a simplified version of [bootstrap-timepicker](http://jdewit.github.io/bootstrap-timepicker/) without the bootstrap dependency and with a more minimal feature-set. 

###Why?
Because
    input type="datetime"
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
  - Shortened some names
  - Added CoffeeScript

The new css, js and html code is just 3.4 KB gzipped and minified. 
The only dependency is JQuery. 

###License
MIT License. Do whatever you want with it. 


##Credit
Timepicker Component
Original version by Joris de Wit - [bootstrap timepicker](http://jdewit.github.io/bootstrap-timepicker/)

CSS Arrows by @Magnus Magnusson
[stackoverflow](http://stackoverflow.com/questions/2701192/ascii-character-for-up-down-triangle-arrow-to-display-in-html)

Modified by Feni Varughese
