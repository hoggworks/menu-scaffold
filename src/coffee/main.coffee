# menu variables
menuData = []
dummyMenuData = [{"name":"item s1", "slug":"item_1", "url":"thing.html"},{"name":"item 2", "slug":"item_2", "children":[{"name":"item_2_1", "slug":"item_2_1", "url":"thing.html", "children":[{"name":"yeehaw?", "slug":"yeehaw", "children":[{"name":"Yeehaw!", "slug":"yeehaw_2", "url":"http://yahoo.com"}]}]}]}, {"name":"item 3", "slug":"item_3"}, {"name":"item 4", "slug":"item_4"}, {"name":"item 5", "slug":"item_5"}, {"name":"item 6", "slug":"item_6"}, {"name":"item 7", "slug":"item_7"}, {"name":"item 8", "slug":"item_8", "children":[{"name":"child of 8", "slug":"child_of_8"}]}, {"name":"item 9", "slug":"item_9"}, {"name":"item 10", "slug":"item_10", "children":[{"name":"1", "slug":"item_1", "url":"thing.html"}, {"name":"2", "slug":"item_2sub", "url":"thing.html"}, {"name":"3", "slug":"item_3", "url":"thing.html"}, {"name":"4", "slug":"item_4", "url":"thing.html"}, {"name":"5", "slug":"item_5", "url":"thing.html", "children":[{"name":"..1", "slug":"item_1", "url":"thing.html"}, {"name":"..2", "slug":"item_1", "url":"thing.html"}, {"name":"..3", "slug":"item_1", "url":"thing.html"}]}]}, {"name":"item 11", "slug":"item_11", "url":"what.html"}, {"name":"item 12", "slug":"item_12", "url":"thing.html", "children":[{"name":"eof", "slug":"eof"}]}]

fitTestText = 'Lorem ipsum dolor sit consectetur adipiscing Mauris at ex id mauris ultrices Praesent blandit faucibus Praesent ac quam et massa lacinia Sed tincidunt fermentum elit sit amet Mauris efficitur libero convallis molestie nulla gravida Etiam eu quam sit amet elit euismod bibendum vitae vel Duis laoreet quis leo et Aenean ipsum laoreet eu euismod convallis et Phasellus lorem consectetur efficitur magna massa consectetur quis pulvinar mauris risus eu Donec quis eros Ut fermentum vitae tellus in Nunc justo malesuada non venenatis ullamcorper id Lorem ipsum dolor sit consectetur adipiscing Mauris at ex id mauris ultrices Praesent blandit faucibus Praesent ac quam et massa lacinia. Holly hanna.Lorem ipsum dolor sit consectetur adipiscing Mauris at ex id mauris ultrices Praesent blandit faucibus Praesent ac quam et massa lacinia Sed tincidunt.'

{ div, a, ol, li, i, span, img } = React.DOM

# instantiate sizeMatters
sizeMatters = new SizeMatters()

$ ->
  ###
    HASH FUNCTIONALITY IS FOR TESTING ONLY
    REMOVE FOR ANY PRODUCTION USE
  ###
  if window.location.hash
    $("body").addClass(window.location.hash.substr(1))

  # variables
  menuPath = 'json/menu.json'

  # load menu json
  $.ajax
    url: menuPath
    dataType: "json"
    type: 'GET'
    error: (jqXHR, textStatus, errorThrown) ->
      console.error("Unable to load menu data remotely: using dummy data")
      parseMenu(dummyMenuData)
    success: (data, textStatus, jqXHR) ->
      parseMenu(data)

  $(window).resize ->
    # close left menu
    if $(window).width() >= 660 and $(".scaffold__modal")
      closeLeftMenu()


    showFitTest()

  showFitTest()

showFitTest = ->
  params =
    text: fitTestText
    target: $("#fit-test")
    className: "fit-test"

  $("#fit-test").html(sizeMatters.howMuchWillFit(params))


parseMenu = (data, par = null) ->
  # menu formatting
  for menu in data
    howBigOptions =
      text: menu.name
      className: "top-menu__item"

    tempData =
      name: menu.name
      slug: menu.slug
      url: menu.url
      leftWidth: null
      visible: 1
      topWidth: sizeMatters.howBigWillThisBe(howBigOptions).width

    if par?
      tempData.parent = par

    tempData.children = menu.slug if menu.children

    menuData.push tempData
    parseMenu(menu.children, menu.slug) if menu.children

  if !par? && data == dummyMenuData
    # finished parsing method
    # draw react component
    drawLeftMenu()
    drawTopMenu()

drawLeftMenu = ->
  # draw react menu
  obj = {menu_data: menuData}
  where = document.getElementById("left-menu__holder")
  React.render(window.LeftMenu(obj), where)

  # handler for menu
  $(".scaffold__menu-close-btn").on "click", ->
    closeLeftMenu()

  $("[class*='left-menu__item']").on "click", ->
    # this method is for all menu items
    showSubMenuItems($(this))

  # open appropriate menus
  # first, build an array of all has_submenu values
  # using the menu that already exists on the screen
  submenus = []

  $("*[data-role='has_submenu']").each ->
    submenus.push $(this).data('children')

  for submenu in submenus
    if $("body").hasClass submenu
      # found the submenu: activate
      subMenuToActivate = $('*[data-children="'+submenu+'"]')
      showSubMenuItems(subMenuToActivate)

      if (subMenuToActivate.data('parent'))
        showAllParentsOf(subMenuToActivate)

drawTopMenu = ->
  obj = {menu_data: menuData}
  where = document.getElementById("top-menu__holder")
  React.render(window.TopMenu(obj), where)

showSubMenuItems = (subMenu) ->
  # if menu item has children, it will toggle the visibility
  if subMenu.data('role') == 'has_submenu'
    child_state = subMenu.data 'child_state'
    new_child_state = 'visible' # default

    if child_state?
      if child_state == 'visible'
        new_child_state = 'hidden'
      else
        new_child_state = 'visible'

    child_element_val = subMenu.data 'children'

    console.log "new child_state", new_child_state, child_element_val

    $("*[data-parent='"+child_element_val+"']").each ->
      if new_child_state == 'hidden'
        # TODO: Replace this with CSS classes
        # presently hidden; show it however
        $(this).slideUp()
        #$(this).hide()

        # does this have any children
        if $(this).data 'children'
          hideAllChildrenOf $(this).data('children')
      else if new_child_state == 'visible'
        $(this).slideDown()

    # update child state
    subMenu.data 'child_state', new_child_state
  else
    # no children, set window.location to data-url attribute
    data_url = subMenu.data 'url'
    if data_url
      window.location = data_url

openLeftMenu = ->
  # add opened classes to menu
  $(".scaffold__menu").addClass "scaffold__menu--open"
  $(".scaffold__content").addClass "scaffold__content--open"

  # add modal to enable off-menu 'close'
  $(".scaffold").append "<div class='scaffold__modal'></div>"
  $(".scaffold__modal").addClass "scaffold__modal--open"

  # add click handler to modal
  $(".scaffold__modal").on "click", ->
    closeLeftMenu()

closeLeftMenu = ->
  $(".scaffold__menu").removeClass "scaffold__menu--open"
  $(".scaffold__content").removeClass "scaffold__content--open"

  # remove modal to disable off-menu 'close'
  $(".scaffold__modal").remove()

###
  Recursive methods for hiding and showing submenu items
###

hideAllChildrenOf = (val) ->
  # this function will select all elements with the appropriate data-parent
  # id, and hide them.
  # it will also recursively call itself on any children of children.

  $("*[data-parent='"+val+"']").each ->
    #$(this).hide()
    $(this).slideUp()

    if $(this).data 'children'
      hideAllChildrenOf $(this).data('children')

  # update child_state of parent element
  $("*[data-children='"+ val + "']").data 'child_state', 'hidden'

showAllParentsOf = (subMenu) ->
  # this function recursively shows all objects in the chain between it and
  # the top level of the page
  parentID = subMenu.data 'parent'
  parentMenuItem = $("*[data-children='" + parentID + "']")

  # show all children of this parent menu item
  showSubMenuItems(parentMenuItem)

  if parentMenuItem.data 'parent'
    showAllParentsOf parentMenuItem

getParentsOf = (item, depth) ->
  hasParent = 0
  item_parent = ''
  depth++
  for menu_item in menuData
    if menu_item.slug == item && menu_item.parent
      hasParent = 1
      item_parent = menu_item.parent

  if hasParent == 1
    return getParentsOf(item_parent, depth)
  else
    return depth


determineDepth = (menu_item) ->
  depth = 1

  # need to go through each menu items, finding array item with the parent.

  if !menu_item.parent
    return depth

  return getParentsOf(menu_item.parent, depth)


###
  REACT Code
###

# LEFT MENU
# BREAK THIS OUT INTO SEPARATE FILE
LeftMenu = React.createFactory React.createClass
  render: ->
    menu_items = @props.menu_data

    div {className: "scaffold__menu-close-btn"},
      "X"
    div {className: "left-menu"},
      for menu_item in menu_items
        LeftMenuItem {item: menu_item}

LeftMenuItem = React.createFactory React.createClass
  render: ->
    menu_item_options = {}
    menu_item = @props.item

    # set params for the menu_item
    if menu_item.children
      # has children; also is a subnav
      menu_item_options['data-role'] = 'has_submenu'
      menu_item_options['data-children'] = menu_item.slug

    if menu_item.parent
      menu_item_options['data-parent'] = menu_item.parent

    if menu_item.url?
      menu_item_options['data-url'] = menu_item.url

    # set the class
    menu_item_options.className = 'left-menu__item-depth-'
    menu_item_options.className += determineDepth(menu_item)

    div menu_item_options,
      menu_item.name

window.LeftMenu = LeftMenu

# TOP MENU
# BREAK THIS OUT INTO SEPARATE FILE

TopMenu = React.createFactory React.createClass
  getInitialState: ->
    mainMenu: []
    overflowMenu: []
    activeSubMenu: []
    menus: {}

  componentWillMount: ->
    window.addEventListener('resize', @recalculateTopMenu)
    @populateMenus()

  componentDidMount: ->
    @populateMenus()

  recalculateTopMenu: ->
    @hideSubMenu()
    @populateMenus()

  componentWillUnMount: ->
    window.removeEventListener('resize', @recalculateTopMenu)

  toggleVisibilityOfChildrenOf: (slug, visibility_value = null) ->
    # this method recursively hides children (and their children)
    # not real, human children, though: I'm talking about child elements.

    # your kids are probably safe.
    menus = @state.menus
    activeMenu = menus[@state.activeSubMenu]

    console.log "slug", slug
    for menu_item in activeMenu

      if menu_item.parent? and menu_item.parent == slug
        console.log "old visibility ", menu_item.visible
        if menu_item.visible == 0
          menu_item.visible = 1
        else if menu_item.visible == 1
          menu_item.visible = 0

        # enact override
        if visibility_value?
          menu_item.visible = visibility_value

        console.log "new visibility ", menu_item.visible

        if menu_item.children? and menu_item.visible == 0
          console.log "going recursive"
          # recursively hide children, but don't recursively show them
          @toggleVisibilityOfChildrenOf(menu_item.children, 0)

    menus[@state.activeSubMenu] = activeMenu


    @setState menus : menus

    console.log @state.menus[@state.activeSubMenu]

  showSubMenuItems: (menu_item) ->
    # if menu item has children, it will toggle the visibility
    if menu_item.children?
      # iterate through active menu items
      # find any with the correct subnavs
      # flip their visibility
      # go down and find children (recursively) and turn off their visibility
      menus = @state.menus[@state.activeSubMenu]
      @toggleVisibilityOfChildrenOf(menu_item.children)
    else
      # no children, set window.location to data-url attribute
      if menu_item.url?
        window.location = menu_item.url

  populateMenus: () ->
    @currentWidth = 0
    mainMenu = []
    overflowMenu = []
    menus = {}

    # how much width is currently available?
    availableWidth = $(".top-menu__main").outerWidth()

    if !availableWidth?
      # initially everything gets dropped in the overflow
      availableWidth = 0

    for menu_item in menuData

      # does this item have children?
      if !menu_item.parent?
        # add to width, ignoring the children elements
        @currentWidth += menu_item.topWidth

        if menu_item.children?
          menus[menu_item.slug] = @generateListOfChildren(menu_item.slug)

      if @currentWidth > availableWidth
        overflowMenu.push menu_item
      else
        mainMenu.push menu_item

    # get all level 1 or higher menus with all submenus


    @setState mainMenu: mainMenu
    @setState overflowMenu: overflowMenu

    # overflow is explicitly referenced
    menus['overflow'] = overflowMenu

    # update menus state
    @setState menus: menus

  showSubMenu: (slug) ->
    # reset visibility
    all_menus = @state.menus
    current_menu = all_menus[slug]
    for menu_item in current_menu
      if menu_item.parent? && menu_item.parent != slug
        menu_item.visible = 0
      else
        menu_item.visible = 1

    all_menus[slug] = current_menu
    @setState menus: all_menus

    # assign sub menu values
    @setState mainParent: slug
    @setState activeSubMenu: slug


  hideSubMenu: ->
    @setState activeSubMenu: []
    @setState mainParent: ''

  generateListOfChildren: (slug) ->
    menu_items = []
    for child_item in menuData
      if child_item.parent == slug
        menu_items.push child_item

        if child_item.children? and child_item.parent?
          child_menu_items = @generateListOfChildren(child_item.children)
          menu_items = menu_items.concat(child_menu_items)
    return menu_items

  render: ->
    # show or hide the overflow menu
    overflow_menu_class = "top-menu__overflow"
    if @state.overflowMenu.length < 1
      overflow_menu_class += "--hidden"

    div {className: "top-menu"},
      div {className: "menu__open-side-menu", onClick:openLeftMenu},
        "MENU"
      div {className: "top-menu__content"},
        div {className: "top-menu__main"},
          for menu_item in @state.mainMenu
            if !menu_item.parent?
              TopMenuItem {
                menu_item: menu_item
                showSubMenu: @showSubMenu
              }
        div {className: overflow_menu_class},
          div
            className: "top-menu__overflow-icon"
            onMouseOver: (e) => @showSubMenu('overflow')
            #onMouseOut: @hideSubMenu
            "***"
        if @state.activeSubMenu > ''
          SubMenu {
            menu: @state.menus[@state.activeSubMenu]
            mainParent: @state.mainParent
            showSubMenuItems: (e) => @showSubMenuItems(e)
          }

TopMenuItem = React.createFactory React.createClass
  showSubMenu: ->
    @props.showSubMenu(@props.menu_item.slug)

  render: ->
    menu_item = @props.menu_item
    menu_item_options =
      className: "top-menu__item"

    if menu_item.children
      # has children; also is a subnav
      menu_item_options['data-role'] = 'has_submenu'
      menu_item_options['data-children'] = menu_item.slug

      # add rollover handler
      menu_item_options.onMouseOver = @showSubMenu
      #menu_item_options.onMouseOut = @hideSubMenu

    if menu_item.parent
      menu_item_options['data-parent'] = menu_item.parent

    if menu_item.url?
      menu_item_options['data-url'] = menu_item.url

    div menu_item_options,
      menu_item.name

window.TopMenu = TopMenu

###
  SUB MENU - THIS IS FOR EVERYTHING THAT DROPS BELOW THE MAIN NAV STRIP
  INCLUDING THE OVERFLOW
###

SubMenu = React.createFactory React.createClass
  getInitialState: ->
    menu: []
    mainParent: ''

  componentDidMount: ->
    @repositionSelf()

  componentDidUpdate: ->
    @repositionSelf()

  repositionSelf: ->
    # this method moves the sub nav under the appropriate menu item
    # TODO: Make this get the position via React, if appropriate?
    if @props.mainParent == 'overflow'
      targ = $(".top-menu__overflow")
    else
      targ = $(".top-menu__main")
      .find('*[data-children="'+@props.mainParent+'"]')

    $(".sub-menu").css('left', (targ.offset().left))

  render: ->
    div {className: "sub-menu"},
      for menu_item in @props.menu
        if menu_item.visible == 1
          SubMenuItem {
            menu_item: menu_item
            showSubMenuItems: (e) => @props.showSubMenuItems(e)
            menu: @props.menu
          }


SubMenuItem = React.createFactory React.createClass
  menuItemClicked: ->
    @props.showSubMenuItems(@props.menu_item)

  render: ->
    menu_item = @props.menu_item

    menu_item_options =
      className: "sub-menu__item"

    if menu_item.children
      # has children; also is a subnav
      menu_item_options['data-role'] = 'has_submenu'
      menu_item_options['data-children'] = menu_item.slug

    if menu_item.parent? and menu_item.parent != @props.mainParent
      menu_item_options['data-parent'] = menu_item.parent

    if menu_item.url?
      menu_item_options['data-url'] = menu_item.url

    menu_item_options.className = 'sub-menu__item-depth-'
    menu_item_options.className += determineDepth(menu_item)
    menu_item_options.onClick = @menuItemClicked

    # only draw if item is currently set to visible
    if !menu_item.hidden?
      div menu_item_options,
        menu_item.name

