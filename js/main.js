$(document).ready(function() {
  // handler for menu
  $(".nav__open-side-nav").on("click", function() {
    openSideNav();
  });

  $(".scaffold__nav-close-btn").on("click", function() {
    closeSideNav();
  });

  $("[class*='left-nav__item']").on("click", function() {
    // this method is for all nav items

    // if nav item has children, it will toggle the visibility
    if ($(this).data('role') == 'has_subnav') {
      var set_children_to;
      var child_state = $(this).data('child_state');
      var new_child_state = child_state == 'visible' ? 'hidden' : 'visible';
      var child_element_val = $(this).data('children');

      $("*[data-parent='"+child_element_val+"']").each(function() {
        if (new_child_state == 'hidden') {
          // presently hidden; show it however
          $(this).slideUp();
          //$(this).hide();

          // does this have any children
          if ($(this).data('children')) {
            hideAllChildrenOf($(this).data('children'));
          }
        } else if (new_child_state == 'visible') {
          $(this).slideDown();
          //$(this).show();
        }
      });

      // update child state
      $(this).data('child_state', new_child_state);
    } else {
      // no children, set window.location to data-url attribute
      var data_url = $(this).data('url');
      if (data_url) {
        window.location = data_url;
      }
    }
  });

  // functions
  function openSideNav() {
    // add opened classes to nav
    $(".scaffold__nav").addClass("scaffold__nav--open");
    $(".scaffold__content").addClass("scaffold__content--open");

    // add modal to enable off-menu 'close'
    $(".scaffold").append("<div class='scaffold__modal'></div>");
    $(".scaffold__modal").addClass("scaffold__modal--open");

    // add click handler to modal
    $(".scaffold__modal").on("click", function() {
      closeSideNav();
    });
  }

  function closeSideNav() {
    $(".scaffold__nav").removeClass("scaffold__nav--open");
    $(".scaffold__content").removeClass("scaffold__content--open");

    // remove modal to disable off-menu 'close'
    $(".scaffold__modal").remove();
  }

  function hideAllChildrenOf(val) {
    // this function will select all elements with the appropriate data-parent
    // id, and hide them.
    // it will also recursively call itself on any children of children.

    console.log('hideAllChildrenOf ', val);

    $("*[data-parent='"+val+"']").each(function() {
      //$(this).hide();
      $(this).slideUp();

      if ($(this).data('children')) {
        hideAllChildrenOf($(this).data('children'));
      }
    });

    // update child_state of parent element
    $("*[data-children='"+val+"']").data('child_state', 'hidden');
  }
});
