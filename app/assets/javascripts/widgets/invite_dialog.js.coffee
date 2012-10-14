$ ->
  invite_menu_link = $("#invite-menu-link")
  if invite_menu_link.length
    invite_menu_link.click ->
      $("#invite_modal").modal("show")
      console.log("click")

    if invite_menu_link.data("need_popover")
      invite_menu_link.popover("show")
