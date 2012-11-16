jQuery ->
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()

$('.join_link').focus -> this.select()

$(".carousel").carousel()


# It's monkey-patch for solving bootstrap bug https://github.com/twitter/bootstrap/issues/5139
# (taked at https://github.com/seyhunak/twitter-bootstrap-rails/issues/404)
jQuery('body').on 'click', jQuery.rails.linkClickSelector, ->
  jQuery(open).removeClass('open') for open in jQuery(this).parents('.dropdown.open')
  jQuery(this).trigger('click.rails')
  false
