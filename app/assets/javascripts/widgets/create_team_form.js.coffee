class CreateTeamFormWidget
  constructor: (dialog) ->
    @dialog = dialog
    @form = @dialog.find("form")
    @dialog.modal()

    @submit_button = @form.find(".btn-primary")
    @submit_button.click =>
      @create()
      false

  create: ->
    @post_data(@close)

  post_data: (success) ->
    form_data = @form.serializeArray()
    $.post("/teams", form_data, success())
    false

  close: ->
    location.href = "/teams/my"

$ ->
  form = $("#new_team_modal")
  if form.length
    new CreateTeamFormWidget(form)
