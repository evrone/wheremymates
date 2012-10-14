jQuery ->
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()

$('.join_link').focus -> this.select()

$(".carousel").carousel()

window.rumbleBannerPlacement = "bottom"
