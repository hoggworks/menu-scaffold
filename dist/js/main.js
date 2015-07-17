// Generated by CoffeeScript 1.9.0
(function() {
  var LeftMenu, LeftMenuItem, SubMenu, SubMenuItem, TopMenu, TopMenuItem, a, closeLeftMenu, determineDepth, div, drawLeftMenu, drawTopMenu, dummyMenuData, fitTestText, getParentsOf, hideAllChildrenOf, i, img, li, menuData, ol, openLeftMenu, parseMenu, showAllParentsOf, showFitTest, showSubMenuItems, sizeMatters, span, _ref;

  menuData = [];

  dummyMenuData = [
    {
      "name": "item s1",
      "slug": "item_1",
      "url": "thing.html"
    }, {
      "name": "item 2",
      "slug": "item_2",
      "children": [
        {
          "name": "item_2_1",
          "slug": "item_2_1",
          "url": "thing.html",
          "children": [
            {
              "name": "yeehaw?",
              "slug": "yeehaw",
              "children": [
                {
                  "name": "Yeehaw!",
                  "slug": "yeehaw_2",
                  "url": "http://yahoo.com"
                }
              ]
            }
          ]
        }
      ]
    }, {
      "name": "item 3",
      "slug": "item_3"
    }, {
      "name": "item 4",
      "slug": "item_4"
    }, {
      "name": "item 5",
      "slug": "item_5"
    }, {
      "name": "item 6",
      "slug": "item_6"
    }, {
      "name": "item 7",
      "slug": "item_7"
    }, {
      "name": "item 8",
      "slug": "item_8",
      "children": [
        {
          "name": "child of 8",
          "slug": "child_of_8"
        }
      ]
    }, {
      "name": "item 9",
      "slug": "item_9"
    }, {
      "name": "item 10",
      "slug": "item_10",
      "children": [
        {
          "name": "1",
          "slug": "item_1",
          "url": "thing.html"
        }, {
          "name": "2",
          "slug": "item_2sub",
          "url": "thing.html"
        }, {
          "name": "3",
          "slug": "item_3",
          "url": "thing.html"
        }, {
          "name": "4",
          "slug": "item_4",
          "url": "thing.html"
        }, {
          "name": "5",
          "slug": "item_5",
          "url": "thing.html",
          "children": [
            {
              "name": "..1",
              "slug": "item_1",
              "url": "thing.html"
            }, {
              "name": "..2",
              "slug": "item_1",
              "url": "thing.html"
            }, {
              "name": "..3",
              "slug": "item_1",
              "url": "thing.html"
            }
          ]
        }
      ]
    }, {
      "name": "item 11",
      "slug": "item_11",
      "url": "what.html"
    }, {
      "name": "item 12",
      "slug": "item_12",
      "url": "thing.html",
      "children": [
        {
          "name": "eof",
          "slug": "eof"
        }
      ]
    }
  ];

  fitTestText = 'Lorem ipsum dolor sit consectetur adipiscing Mauris at ex id mauris ultrices Praesent blandit faucibus Praesent ac quam et massa lacinia Sed tincidunt fermentum elit sit amet Mauris efficitur libero convallis molestie nulla gravida Etiam eu quam sit amet elit euismod bibendum vitae vel Duis laoreet quis leo et Aenean ipsum laoreet eu euismod convallis et Phasellus lorem consectetur efficitur magna massa consectetur quis pulvinar mauris risus eu Donec quis eros Ut fermentum vitae tellus in Nunc justo malesuada non venenatis ullamcorper id Lorem ipsum dolor sit consectetur adipiscing Mauris at ex id mauris ultrices Praesent blandit faucibus Praesent ac quam et massa lacinia. Holly hanna.Lorem ipsum dolor sit consectetur adipiscing Mauris at ex id mauris ultrices Praesent blandit faucibus Praesent ac quam et massa lacinia Sed tincidunt.';

  _ref = React.DOM, div = _ref.div, a = _ref.a, ol = _ref.ol, li = _ref.li, i = _ref.i, span = _ref.span, img = _ref.img;

  sizeMatters = new SizeMatters();

  $(function() {

    /*
      HASH FUNCTIONALITY IS FOR TESTING ONLY
      REMOVE FOR ANY PRODUCTION USE
     */
    var menuPath;
    if (window.location.hash) {
      $("body").addClass(window.location.hash.substr(1));
    }
    menuPath = 'json/menu.json';
    $.ajax({
      url: menuPath,
      dataType: "json",
      type: 'GET',
      error: function(jqXHR, textStatus, errorThrown) {
        console.error("Unable to load menu data remotely: using dummy data");
        return parseMenu(dummyMenuData);
      },
      success: function(data, textStatus, jqXHR) {
        return parseMenu(data);
      }
    });
    $(window).resize(function() {
      if ($(window).width() >= 660 && $(".scaffold__modal")) {
        closeLeftMenu();
      }
      return showFitTest();
    });
    return showFitTest();
  });

  showFitTest = function() {
    var params;
    params = {
      text: fitTestText,
      target: $("#fit-test"),
      className: "fit-test"
    };
    return $("#fit-test").html(sizeMatters.howMuchWillFit(params));
  };

  parseMenu = function(data, par) {
    var howBigOptions, menu, tempData, _i, _len;
    if (par == null) {
      par = null;
    }
    for (_i = 0, _len = data.length; _i < _len; _i++) {
      menu = data[_i];
      howBigOptions = {
        text: menu.name,
        className: "top-menu__item"
      };
      tempData = {
        name: menu.name,
        slug: menu.slug,
        url: menu.url,
        leftWidth: null,
        visible: 1,
        topWidth: sizeMatters.howBigWillThisBe(howBigOptions).width
      };
      if (par != null) {
        tempData.parent = par;
      }
      if (menu.children) {
        tempData.children = menu.slug;
      }
      menuData.push(tempData);
      if (menu.children) {
        parseMenu(menu.children, menu.slug);
      }
    }
    if ((par == null) && data === dummyMenuData) {
      drawLeftMenu();
      return drawTopMenu();
    }
  };

  drawLeftMenu = function() {
    var obj, subMenuToActivate, submenu, submenus, where, _i, _len, _results;
    obj = {
      menu_data: menuData
    };
    where = document.getElementById("left-menu__holder");
    React.render(window.LeftMenu(obj), where);
    $(".scaffold__menu-close-btn").on("click", function() {
      return closeLeftMenu();
    });
    $("[class*='left-menu__item']").on("click", function() {
      return showSubMenuItems($(this));
    });
    submenus = [];
    $("*[data-role='has_submenu']").each(function() {
      return submenus.push($(this).data('children'));
    });
    _results = [];
    for (_i = 0, _len = submenus.length; _i < _len; _i++) {
      submenu = submenus[_i];
      if ($("body").hasClass(submenu)) {
        subMenuToActivate = $('*[data-children="' + submenu + '"]');
        showSubMenuItems(subMenuToActivate);
        if (subMenuToActivate.data('parent')) {
          _results.push(showAllParentsOf(subMenuToActivate));
        } else {
          _results.push(void 0);
        }
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };

  drawTopMenu = function() {
    var obj, where;
    obj = {
      menu_data: menuData
    };
    where = document.getElementById("top-menu__holder");
    return React.render(window.TopMenu(obj), where);
  };

  showSubMenuItems = function(subMenu) {
    var child_element_val, child_state, data_url, new_child_state;
    if (subMenu.data('role') === 'has_submenu') {
      child_state = subMenu.data('child_state');
      new_child_state = 'visible';
      if (child_state != null) {
        if (child_state === 'visible') {
          new_child_state = 'hidden';
        } else {
          new_child_state = 'visible';
        }
      }
      child_element_val = subMenu.data('children');
      console.log("new child_state", new_child_state, child_element_val);
      $("*[data-parent='" + child_element_val + "']").each(function() {
        if (new_child_state === 'hidden') {
          $(this).slideUp();
          if ($(this).data('children')) {
            return hideAllChildrenOf($(this).data('children'));
          }
        } else if (new_child_state === 'visible') {
          return $(this).slideDown();
        }
      });
      return subMenu.data('child_state', new_child_state);
    } else {
      data_url = subMenu.data('url');
      if (data_url) {
        return window.location = data_url;
      }
    }
  };

  openLeftMenu = function() {
    $(".scaffold__menu").addClass("scaffold__menu--open");
    $(".scaffold__content").addClass("scaffold__content--open");
    $(".scaffold").append("<div class='scaffold__modal'></div>");
    $(".scaffold__modal").addClass("scaffold__modal--open");
    return $(".scaffold__modal").on("click", function() {
      return closeLeftMenu();
    });
  };

  closeLeftMenu = function() {
    $(".scaffold__menu").removeClass("scaffold__menu--open");
    $(".scaffold__content").removeClass("scaffold__content--open");
    return $(".scaffold__modal").remove();
  };


  /*
    Recursive methods for hiding and showing submenu items
   */

  hideAllChildrenOf = function(val) {
    $("*[data-parent='" + val + "']").each(function() {
      $(this).slideUp();
      if ($(this).data('children')) {
        return hideAllChildrenOf($(this).data('children'));
      }
    });
    return $("*[data-children='" + val + "']").data('child_state', 'hidden');
  };

  showAllParentsOf = function(subMenu) {
    var parentID, parentMenuItem;
    parentID = subMenu.data('parent');
    parentMenuItem = $("*[data-children='" + parentID + "']");
    showSubMenuItems(parentMenuItem);
    if (parentMenuItem.data('parent')) {
      return showAllParentsOf(parentMenuItem);
    }
  };

  getParentsOf = function(item, depth) {
    var hasParent, item_parent, menu_item, _i, _len;
    hasParent = 0;
    item_parent = '';
    depth++;
    for (_i = 0, _len = menuData.length; _i < _len; _i++) {
      menu_item = menuData[_i];
      if (menu_item.slug === item && menu_item.parent) {
        hasParent = 1;
        item_parent = menu_item.parent;
      }
    }
    if (hasParent === 1) {
      return getParentsOf(item_parent, depth);
    } else {
      return depth;
    }
  };

  determineDepth = function(menu_item) {
    var depth;
    depth = 1;
    if (!menu_item.parent) {
      return depth;
    }
    return getParentsOf(menu_item.parent, depth);
  };


  /*
    REACT Code
   */

  LeftMenu = React.createFactory(React.createClass({
    render: function() {
      var menu_item, menu_items;
      menu_items = this.props.menu_data;
      div({
        className: "scaffold__menu-close-btn"
      }, "X");
      return div({
        className: "left-menu"
      }, (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = menu_items.length; _i < _len; _i++) {
          menu_item = menu_items[_i];
          _results.push(LeftMenuItem({
            item: menu_item
          }));
        }
        return _results;
      })());
    }
  }));

  LeftMenuItem = React.createFactory(React.createClass({
    render: function() {
      var menu_item, menu_item_options;
      menu_item_options = {};
      menu_item = this.props.item;
      if (menu_item.children) {
        menu_item_options['data-role'] = 'has_submenu';
        menu_item_options['data-children'] = menu_item.slug;
      }
      if (menu_item.parent) {
        menu_item_options['data-parent'] = menu_item.parent;
      }
      if (menu_item.url != null) {
        menu_item_options['data-url'] = menu_item.url;
      }
      menu_item_options.className = 'left-menu__item-depth-';
      menu_item_options.className += determineDepth(menu_item);
      return div(menu_item_options, menu_item.name);
    }
  }));

  window.LeftMenu = LeftMenu;

  TopMenu = React.createFactory(React.createClass({
    getInitialState: function() {
      return {
        mainMenu: [],
        overflowMenu: [],
        activeSubMenu: [],
        menus: {}
      };
    },
    componentWillMount: function() {
      window.addEventListener('resize', this.recalculateTopMenu);
      return this.populateMenus();
    },
    componentDidMount: function() {
      return this.populateMenus();
    },
    recalculateTopMenu: function() {
      this.hideSubMenu();
      return this.populateMenus();
    },
    componentWillUnMount: function() {
      return window.removeEventListener('resize', this.recalculateTopMenu);
    },
    toggleVisibilityOfChildrenOf: function(slug, visibility_value) {
      var activeMenu, menu_item, menus, _i, _len;
      if (visibility_value == null) {
        visibility_value = null;
      }
      menus = this.state.menus;
      activeMenu = menus[this.state.activeSubMenu];
      console.log("slug", slug);
      for (_i = 0, _len = activeMenu.length; _i < _len; _i++) {
        menu_item = activeMenu[_i];
        if ((menu_item.parent != null) && menu_item.parent === slug) {
          console.log("old visibility ", menu_item.visible);
          if (menu_item.visible === 0) {
            menu_item.visible = 1;
          } else if (menu_item.visible === 1) {
            menu_item.visible = 0;
          }
          if (visibility_value != null) {
            menu_item.visible = visibility_value;
          }
          console.log("new visibility ", menu_item.visible);
          if ((menu_item.children != null) && menu_item.visible === 0) {
            console.log("going recursive");
            this.toggleVisibilityOfChildrenOf(menu_item.children, 0);
          }
        }
      }
      menus[this.state.activeSubMenu] = activeMenu;
      this.setState({
        menus: menus
      });
      return console.log(this.state.menus[this.state.activeSubMenu]);
    },
    showSubMenuItems: function(menu_item) {
      var menus;
      if (menu_item.children != null) {
        menus = this.state.menus[this.state.activeSubMenu];
        return this.toggleVisibilityOfChildrenOf(menu_item.children);
      } else {
        if (menu_item.url != null) {
          return window.location = menu_item.url;
        }
      }
    },
    populateMenus: function() {
      var availableWidth, mainMenu, menu_item, menus, overflowMenu, _i, _len;
      this.currentWidth = 0;
      mainMenu = [];
      overflowMenu = [];
      menus = {};
      availableWidth = $(".top-menu__main").outerWidth();
      if (availableWidth == null) {
        availableWidth = 0;
      }
      for (_i = 0, _len = menuData.length; _i < _len; _i++) {
        menu_item = menuData[_i];
        if (menu_item.parent == null) {
          this.currentWidth += menu_item.topWidth;
          if (menu_item.children != null) {
            menus[menu_item.slug] = this.generateListOfChildren(menu_item.slug);
          }
        }
        if (this.currentWidth > availableWidth) {
          overflowMenu.push(menu_item);
        } else {
          mainMenu.push(menu_item);
        }
      }
      this.setState({
        mainMenu: mainMenu
      });
      this.setState({
        overflowMenu: overflowMenu
      });
      menus['overflow'] = overflowMenu;
      return this.setState({
        menus: menus
      });
    },
    showSubMenu: function(slug) {
      var all_menus, current_menu, menu_item, _i, _len;
      all_menus = this.state.menus;
      current_menu = all_menus[slug];
      for (_i = 0, _len = current_menu.length; _i < _len; _i++) {
        menu_item = current_menu[_i];
        if ((menu_item.parent != null) && menu_item.parent !== slug) {
          menu_item.visible = 0;
        } else {
          menu_item.visible = 1;
        }
      }
      all_menus[slug] = current_menu;
      this.setState({
        menus: all_menus
      });
      this.setState({
        mainParent: slug
      });
      return this.setState({
        activeSubMenu: slug
      });
    },
    hideSubMenu: function() {
      this.setState({
        activeSubMenu: []
      });
      return this.setState({
        mainParent: ''
      });
    },
    generateListOfChildren: function(slug) {
      var child_item, child_menu_items, menu_items, _i, _len;
      menu_items = [];
      for (_i = 0, _len = menuData.length; _i < _len; _i++) {
        child_item = menuData[_i];
        if (child_item.parent === slug) {
          menu_items.push(child_item);
          if ((child_item.children != null) && (child_item.parent != null)) {
            child_menu_items = this.generateListOfChildren(child_item.children);
            menu_items = menu_items.concat(child_menu_items);
          }
        }
      }
      return menu_items;
    },
    render: function() {
      var menu_item, overflow_menu_class;
      overflow_menu_class = "top-menu__overflow";
      if (this.state.overflowMenu.length < 1) {
        overflow_menu_class += "--hidden";
      }
      return div({
        className: "top-menu"
      }, div({
        className: "menu__open-side-menu",
        onClick: openLeftMenu
      }, "MENU"), div({
        className: "top-menu__content"
      }, div({
        className: "top-menu__main"
      }, (function() {
        var _i, _len, _ref1, _results;
        _ref1 = this.state.mainMenu;
        _results = [];
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          menu_item = _ref1[_i];
          if (menu_item.parent == null) {
            _results.push(TopMenuItem({
              menu_item: menu_item,
              showSubMenu: this.showSubMenu
            }));
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      }).call(this)), div({
        className: overflow_menu_class
      }, div({
        className: "top-menu__overflow-icon",
        onMouseOver: (function(_this) {
          return function(e) {
            return _this.showSubMenu('overflow');
          };
        })(this)
      }, "***")), this.state.activeSubMenu > '' ? SubMenu({
        menu: this.state.menus[this.state.activeSubMenu],
        mainParent: this.state.mainParent,
        showSubMenuItems: (function(_this) {
          return function(e) {
            return _this.showSubMenuItems(e);
          };
        })(this)
      }) : void 0));
    }
  }));

  TopMenuItem = React.createFactory(React.createClass({
    showSubMenu: function() {
      return this.props.showSubMenu(this.props.menu_item.slug);
    },
    render: function() {
      var menu_item, menu_item_options;
      menu_item = this.props.menu_item;
      menu_item_options = {
        className: "top-menu__item"
      };
      if (menu_item.children) {
        menu_item_options['data-role'] = 'has_submenu';
        menu_item_options['data-children'] = menu_item.slug;
        menu_item_options.onMouseOver = this.showSubMenu;
      }
      if (menu_item.parent) {
        menu_item_options['data-parent'] = menu_item.parent;
      }
      if (menu_item.url != null) {
        menu_item_options['data-url'] = menu_item.url;
      }
      return div(menu_item_options, menu_item.name);
    }
  }));

  window.TopMenu = TopMenu;


  /*
    SUB MENU - THIS IS FOR EVERYTHING THAT DROPS BELOW THE MAIN NAV STRIP
    INCLUDING THE OVERFLOW
   */

  SubMenu = React.createFactory(React.createClass({
    getInitialState: function() {
      return {
        menu: [],
        mainParent: ''
      };
    },
    componentDidMount: function() {
      return this.repositionSelf();
    },
    componentDidUpdate: function() {
      return this.repositionSelf();
    },
    repositionSelf: function() {
      var targ;
      if (this.props.mainParent === 'overflow') {
        targ = $(".top-menu__overflow");
      } else {
        targ = $(".top-menu__main").find('*[data-children="' + this.props.mainParent + '"]');
      }
      return $(".sub-menu").css('left', (targ.offset().left));
    },
    render: function() {
      var menu_item;
      return div({
        className: "sub-menu"
      }, (function() {
        var _i, _len, _ref1, _results;
        _ref1 = this.props.menu;
        _results = [];
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          menu_item = _ref1[_i];
          if (menu_item.visible === 1) {
            _results.push(SubMenuItem({
              menu_item: menu_item,
              showSubMenuItems: (function(_this) {
                return function(e) {
                  return _this.props.showSubMenuItems(e);
                };
              })(this),
              menu: this.props.menu
            }));
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      }).call(this));
    }
  }));

  SubMenuItem = React.createFactory(React.createClass({
    menuItemClicked: function() {
      return this.props.showSubMenuItems(this.props.menu_item);
    },
    render: function() {
      var menu_item, menu_item_options;
      menu_item = this.props.menu_item;
      menu_item_options = {
        className: "sub-menu__item"
      };
      if (menu_item.children) {
        menu_item_options['data-role'] = 'has_submenu';
        menu_item_options['data-children'] = menu_item.slug;
      }
      if ((menu_item.parent != null) && menu_item.parent !== this.props.mainParent) {
        menu_item_options['data-parent'] = menu_item.parent;
      }
      if (menu_item.url != null) {
        menu_item_options['data-url'] = menu_item.url;
      }
      menu_item_options.className = 'sub-menu__item-depth-';
      menu_item_options.className += determineDepth(menu_item);
      menu_item_options.onClick = this.menuItemClicked;
      if (menu_item.hidden == null) {
        return div(menu_item_options, menu_item.name);
      }
    }
  }));

}).call(this);
