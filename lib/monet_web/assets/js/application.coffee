#= require jquery.js
#= require bootstrap.js

DEFAULT_OPTIONS = {
  placement: 'bottom'
}

window.attachTooltip = (el, title, options={}) ->
  opts = $.extend {}, DEFAULT_OPTIONS, {title: title}, options
  $(el).tooltip opts

