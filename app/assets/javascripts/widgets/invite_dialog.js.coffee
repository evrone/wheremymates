class InviteDialod
  constructor: (invite_menu_link) ->
    @menu_link = invite_menu_link
    @modal = $("#invite_modal")
    @menu_link.click =>
      @show()

    if @menu_link.data("need_popover")
      @menu_link.popover("show")

    @done_button = @modal.find(".btn-primary")
    @done_button.click =>
      @close()

  show: ->
    @menu_link.popover("hide")
    @modal.modal("show")

  close: ->
    @modal.modal("hide")

$ ->
  invite_menu_link = $("#invite-menu-link")
  if invite_menu_link.length
    new InviteDialod(invite_menu_link)
