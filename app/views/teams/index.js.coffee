container = $('#modals')
modal = container.find('.index_teams')

if modal.length
  modal.modal('show')
else
  container.append("<%=j render 'index_modal' %>")
  container.find('.index_teams').modal()
