{ div, a, ol, li, i, span, img } = React.DOM

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
    menu_item_options.className += window.determineDepth(menu_item)
    menu_item_options.onClick = @menuItemClicked

    # only draw if item is currently set to visible
    if !menu_item.hidden?
      div menu_item_options,
        menu_item.name

window.SubMenu = SubMenu
