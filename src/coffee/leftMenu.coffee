{ div, a, ol, li, i, span, img } = React.DOM

# LEFT MENU
LeftMenu = React.createFactory React.createClass
  getInitialState: ->
    showModal: false
    menu: @setInitialVisibility(@props.menu_data)

  setInitialVisibility: (menu) ->
    for menu_item in menu
      menu_item.visible = 0 if menu_item.parent?

    return menu

  open: ->
    @setState showModal: true

  toggleVisibilityOfChildrenOf: (slug, visibility_value = null) ->
    # this method recursively hides children (and their children)
    # not real, human children, though: I'm talking about child elements.

    # your kids are probably safe.
    activeMenu = @state.menu

    for menu_item in activeMenu

      if menu_item.parent? and menu_item.parent == slug
        if menu_item.visible == 0
          menu_item.visible = 1
        else if menu_item.visible == 1
          menu_item.visible = 0

        # enact override
        if visibility_value?
          menu_item.visible = visibility_value

        if menu_item.children? and menu_item.visible == 0
          # recursively hide children, but don't recursively show them
          @toggleVisibilityOfChildrenOf(menu_item.children, 0)

    @setState menu : activeMenu


  showSubMenu: (slug) ->
    # reset visibility
    menu = @state.menu

    for menu_item in menu
      if menu_item.parent? && menu_item.parent != slug
        menu_item.visible = 0
      else
        menu_item.visible = 1

    @setState menu: menu

  showSubMenuItems: (menu_item) ->
    # if menu item has children, it will toggle the visibility
    if menu_item.children?
      # iterate through active menu items
      # find any with the correct subnavs
      # flip their visibility
      # go down and find children (recursively) and turn off their visibility
      menus = @state.menu
      @toggleVisibilityOfChildrenOf(menu_item.children)
    else
      # no children, set window.location to data-url attribute
      if menu_item.url?
        window.location = menu_item.url

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
    menu_items = @props.menu_data
    div {className: "scaffold__menu-close-btn"},
      "X"
    div {className: "left-menu"},
      for menu_item in menu_items
        if menu_item.visible == 1
          LeftMenuItem {
            menu_item: menu_item
            showSubMenuItems: (e) => @showSubMenuItems(e)
          }

LeftMenuItem = React.createFactory React.createClass
  menuItemClicked: ->
    console.log @props.menu_item
    @props.showSubMenuItems(@props.menu_item)

  render: ->
    menu_item_options = {}
    menu_item = @props.menu_item

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
    menu_item_options.className += window.determineDepth(menu_item)

    # click handler

    menu_item_options.onClick = @menuItemClicked

    div menu_item_options,
      menu_item.name

window.LeftMenu = LeftMenu
