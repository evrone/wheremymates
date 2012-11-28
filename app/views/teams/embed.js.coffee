container = $('#modals')
modal = container.find('.embed_team_modal')

if modal.length
  modal.modal('show')
else
  container.append("<%=j render 'embed_modal' %>")
  container.find('.embed_team_modal').modal()
