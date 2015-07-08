$(document).ready(function() {
  // handler for menu
  $(".nav__open-side-nav").on("click", function() {
    openSideNav();
  });

  $(".scaffold__nav-close-btn").on("click", function() {
    closeSideNav();
  });

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
});
