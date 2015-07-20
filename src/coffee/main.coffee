# menu variables
window.menuData = menuData = []
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

window.openLeftMenu = ->
  # add opened classes to menu
  $(".scaffold__menu").addClass "scaffold__menu--open"
  $(".scaffold__content").addClass "scaffold__content--open"

window.closeLeftMenu = ->
  $(".scaffold__menu").removeClass "scaffold__menu--open"
  $(".scaffold__content").removeClass "scaffold__content--open"

###
  Recursive methods for hiding and showing submenu items
###


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


window.determineDepth = (menu_item) ->
  depth = 1

  # need to go through each menu items, finding array item with the parent.

  if !menu_item.parent
    return depth

  return getParentsOf(menu_item.parent, depth)
