container = $('#modals')
modal = container.find('.index_teams')

unless modal.length
  container.append("<%=j render 'index_modal' %>")
  modal = container.find('.index_teams')
  modal.modal()

modal.modal('show')
