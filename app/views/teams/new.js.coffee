container = $('#modals')
modal = container.find('.new_team_modal')

if modal.length
  modal.modal('show')
else
  container.append("<%=j render 'new_form' %>")
  container.find('.new_team_modal').modal()
