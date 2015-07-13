class window.SizeMatters
  # variables go here
  housingDivID = "_sizeMattersHousing"
  housingDivStyle = "opacity: 0; left: -100000px; top: -100000px;"
  housingDiv = ''

  ###
    PRIVATE METHODS
  ###
  constructor: (namespace) ->
    return false if !this.doesjQueryExist()

    # override default namespace
    if namespace?
      housingDivID = namespace

    # create dummy
    @housingDivString = "<div id='#{housingDivID}'></div>"

  doesjQueryExist: ->
    if (jQuery)
      return true
    else
      console.warn "SizeMatters requires jQuery to run."
      return false


  ###
    PUBLIC METHODS
  ###
  willItFit: (text, params) ->
    return false if !this.doesjQueryExist()

  howMuchWillFit: (text, params) ->
    return false if !this.doesjQueryExist()

  howBigWillThisBe: (text, params) ->
    return false if !this.doesjQueryExist()

    # create housing
    $("body").append(@housingDivString)

    housingDiv = $("##{housingDivID}")

    # collect params
    if typeof text is 'string'
      # assuming that params is an object
      divText = text
      divParams = params
    else if typeof text is 'object'
      # assuming text is actually an object
      divText = text.text
      divParams = text

    if divParams.className?
      # assuming a defined class nam
      newItem = "<div id='_sizeMatters_tempItem' "
      newItem += "class='#{divParams.className}'>"
    else
      newItem = '<div style="'

      # probably there's a more elegant way to do this
      if divParams.fontFamily?
        newItem += "font-family: #{divParams.font-family}; "

      if divParams.fontSize?
        newItem += "font-size: #{divParams.font-size}; "

      if divParams.width?
        newItem += "width: #{divParams.width}; "


    # close style
    newItem += "'>"

    # add in provided text
    newItem += divText

    # create div
    newItem += '</div>'

    # add to screen
    housingDiv.append(newItem)

    # handler for new item
    tempItemHandle = housingDiv.find("#_sizeMatters_tempItem")

    # calculate margins
    # TODO: Intelligently add code to add margins and padding from class or
    # params.

    # get dimensions
    dimensions =
      width: tempItemHandle.width() + margins
      height: tempItemHandle.height() + paddings

    # remove dummy item
    tempItemHandle.remove()

    # remove housing
    housingDiv.remove()

    return dimensions
