# menu variables
menuData = []
dummyMenuData = [{"name":"item s1", "slug":"item_1", "url":"thing.html"},{"name":"item 2", "slug":"item_2", "children":[{"name":"item_2_1", "slug":"item_2_1", "url":"thing.html", "children":[{"name":"yeehaw?", "slug":"yeehaw", "children":[{"name":"Yeehaw!", "slug":"yeehaw_2"}]}]}]}, {"name":"item 3", "slug":"item_3"}]

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
      #console.log("error retrieving data " + jqXHR.responseText)
      console.error("Unable to load menu data remotely: using dummy data")
      parseMenu(dummyMenuData)
    success: (data, textStatus, jqXHR) ->
      parseMenu(data)


parseMenu = (data, par = null) ->
  # left menu formatting
  for menu in data
    # thing
    tempData =
      name: menu.name
      slug: menu.slug
      url: menu.url
      leftWidth: null
      topWidth: null

    howBigOptions =
      text: menu.name
      className: "top-menu__item"

    console.log sizeMatters.howBigWillThisBe(howBigOptions)

    tempData.parent = par if par
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
  $(".menu__open-side-menu").on "click", ->
    openSideMenu()

  $(".scaffold__menu-close-btn").on "click", ->
    closeSideMenu()

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
        $(this).show()

    # update child state
    subMenu.data 'child_state', new_child_state
  else
    # no children, set window.location to data-url attribute
    data_url = subMenu.data 'url'
    if data_url
      window.location = data_url

openSideMenu = ->
  # add opened classes to menu
  $(".scaffold__menu").addClass "scaffold__menu--open"
  $(".scaffold__content").addClass "scaffold__content--open"

  # add modal to enable off-menu 'close'
  $(".scaffold").append "<div class='scaffold__modal'></div>"
  $(".scaffold__modal").addClass "scaffold__modal--open"

  # add click handler to modal
  $(".scaffold__modal").on "click", ->
    closeSideMenu()

closeSideMenu = ->
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

  componentWillMount: ->
    @populateMenus()

  populateMenus: () ->
    @currentWidth = 0
    mainMenu = []
    overflowMenu = []

    availableWidth = 100000
    console.log menuData
    for menu_item in menuData
      @currentWidth += menu_item.topWidth

      console.log @currentWidth

      if @currentWidth > availableWidth
        overflowMenu.push menu_item
      else
        mainMenu.push menu_item

    @setState mainMenu: mainMenu
    @setState overflowMenu: overflowMenu

    @render()


  render: ->
    div {className: "top-menu"},
      div {className: "top-menu__main"},
        for menu_item in @state.mainMenu
          div {className: "top-menu__item"},
            menu_item.name
      div {className: "top-menu__overflow"},
        div {className: "top-menu__overflow-icon"},
          "***"
        div {className: "top-menu__overflow-content"},
          for menu_item in @state.overflowMenu
            div {className: "top-menu__item"},
              menu_item.name

window.TopMenu = TopMenu
