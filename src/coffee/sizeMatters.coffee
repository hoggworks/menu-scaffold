class window.SizeMatters
  # variables go here
  housingDivID = "_sizeMattersHousing"
  housingDivStyle = "opacity: 0; left: -100000px; top: -100000px;"
  housingDiv = ''

  defaultSuffix = '...'

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

    ###
      Requires
      text -  either as a string as the first params
              or as a param of a has passed as the first param
      className - just a class name
      width
      height    - Either defined explicitly as a param,
                  or extracted from DOM reference
      target    - DOM reference to extract height and width from
    ###

    # collect params
    if typeof text is 'string'
      # assuming that params is an object
      divText = text
      divParams = params
    else if typeof text is 'object'
      # assuming text is actually an object
      divText = text.text
      divParams = text

    if !divParams.suffix?
      suffix = defaultSuffix
    else
      suffix = divParams.suffix

    # TODO: Make this non-destructive
    #fullText = divText.match(/[a-zA-Z!@#$^&*().]+[$\s+]/gi)
    fullText = divText.split(/(\S+\s+)/).filter (n) -> n
    currentText = fullText.join("")

    # If a target isn't provided, assume height/width are set.
    if !divParams.target?
      comparisonWidth = divParams.width
      comparisonHeight = divParams.height
    else
      comparisonWidth = divParams.target.width()
      comparisonHeight = divParams.target.height()

    distance = Math.floor(fullText.length/2)

    # check full text first
    checkIndex = fullText.length-1

    while distance > 1
      # add width to divParams
      divParams.width = divParams.target.width() + "px"

      # run comparison
      dimensions = @howBigWillThisBe currentText, divParams

      if dimensions.width <= comparisonWidth and
       dimensions.height <= comparisonHeight
        # the current text will be small enough, but
        # it might be too small, so go up the chain.
        checkDirection = 1
        distance = Math.floor(distance / 2) - 1

        # if full text is visible, break out of loop
        if checkIndex == fullText.length - 1
          break
      else
        # current text isn't small enough; keep going
        # down the chain.
        checkDirection = -1

      checkIndex += Math.floor(checkDirection*(distance))

      currentText = fullText
      .slice(0, checkIndex)
      .join("")+suffix

    # send back result
    if currentText == suffix
      return "ERROR"
    else
      return currentText

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
      newItem += "class='#{divParams.className}'"

    # override style elements
    newItem += " style='"

    # probably there's a more elegant way to do this
    if divParams.fontFamily?
      newItem += "font-family: #{divParams.font-family}; "

    if divParams.fontSize?
      newItem += "font-size: #{divParams.font-size}; "

    if divParams.width?
      newItem += "width: #{divParams.width} !important;"

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

    # get dimensions
    item_width = tempItemHandle.width()
    item_height = tempItemHandle.height()

    # adjust for margins
    margin = parseFloat(tempItemHandle.css('margin'))
    marginLeft = parseFloat(tempItemHandle.css('margin-left'))
    marginRight = parseFloat(tempItemHandle.css('margin-right'))
    marginTop = parseFloat(tempItemHandle.css('margin-top'))
    marginBottom = parseFloat(tempItemHandle.css('margin-bottom'))

    if margin
      # *2 is to apply both margin sides
      item_width += margin*2
      item_height += margin*2
    else
      if marginLeft
        item_width += marginLeft

      if marginRight
        item_width += marginRight

      if marginTop
        item_height += marginTop

      if marginBottom
        item_height += marginBottom

    # adjust for padding
    # TODO: Add exception for the box-type display, so it won't
    # add padding if the appropriate CSS style is set
    padding = parseFloat(tempItemHandle.css('padding'))
    paddingLeft = parseFloat(tempItemHandle.css('padding-left'))
    paddingRight = parseFloat(tempItemHandle.css('padding-right'))
    paddingTop = parseFloat(tempItemHandle.css('padding-top'))
    paddingBottom = parseFloat(tempItemHandle.css('padding-bottom'))

    if padding
      # *2 is to apply both padding sides
      item_width += padding*2
      item_height += padding*2
    else
      if paddingLeft
        item_width += paddingLeft

      if paddingRight
        item_width += paddingRight

      if paddingTop
        item_height += paddingTop

      if paddingBottom
        item_height += paddingBottom

    dimensions =
      width: item_width
      height: item_height

    # remove dummy item
    tempItemHandle.remove()

    # remove housing
    housingDiv.remove()

    return dimensions
