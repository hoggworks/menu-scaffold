$ ->
  ###
    HASH FUNCTIONALITY IS FOR TESTING ONLY
    REMOVE FOR ANY PRODUCTION USE
  ###

  if window.location.hash
    $("body").addClass(window.location.hash.substr(1))

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
