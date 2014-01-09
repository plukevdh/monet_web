#= require 'jquery'
#= require bootstrap

DEFAULT_OPTIONS = {
  placement: 'bottom'
}

window.attachTooltip = (el, title) ->
  opts = $.extend {}, DEFAULT_OPTIONS, {title: title}
  $(el).tooltip opts

attachTooltip '.compare img', "Compare Images"
attachTooltip '.swap img', "Accept new"
attachTooltip '.reject img', "Reject new"

