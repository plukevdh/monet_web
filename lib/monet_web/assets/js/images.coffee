attachTooltip '.compare img', "Compare Images"
attachTooltip '.swap img', "Accept new"
attachTooltip '.reject img', "Reject new"
attachTooltip 'img.errored', ->
    error = $(@).data('title')
    msg = "Error: #{error}"
  , {placement: 'top'}


