{ div, a, ol, li, i, span, img } = React.DOM

TopMenu = React.createFactory React.createClass
  getInitialState: ->
    mainMenu: []
    overflowMenu: []
    activeSubMenu: []
    menus: {}
    showModal: false

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

    menus[@state.activeSubMenu] = activeMenu
    @setState menus : menus

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
    availableWidth = $(".top-menu__main").outerWidth() - 20

    if !availableWidth?
      # initially everything gets dropped in the overflow
      availableWidth = 0

    for menu_item in menuData

      # does this item have children?
      if !menu_item.parent?
        # add to width, ignoring the children elements
        menu_item.visible = 1
        @currentWidth += menu_item.topWidth

        if menu_item.children?
          menus[menu_item.slug] = @generateListOfChildren(menu_item.slug)

      else
        menu_item.visible = 0

      if @currentWidth > availableWidth
        overflowMenu.push menu_item
      else
        mainMenu.push menu_item

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

  openLeftMenu: ->
    @setState showModal: true
    window.openLeftMenu()

  closeLeftMenu: ->
    @setState showModal: false
    window.closeLeftMenu()

  render: ->
    # show or hide the overflow menu
    overflow_menu_class = "top-menu__overflow"
    if @state.overflowMenu.length < 1
      overflow_menu_class += "--hidden"

    div {className: "top-menu"},
      div {className: "menu__open-side-menu", onClick:@openLeftMenu},
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
          window.SubMenu {
            menu: @state.menus[@state.activeSubMenu]
            mainParent: @state.mainParent
            showSubMenuItems: (e) => @showSubMenuItems(e)
          }
      if @state.showModal == true
        Modal { closeLeftMenu: @closeLeftMenu }

Modal = React.createFactory React.createClass

  render: ->
    div
      className: 'scaffold__modal'
      onClick: @props.closeLeftMenu

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
