class CreateTeamFormWidget
  constructor: (dialog) ->
    @dialog = dialog
    @form = @dialog.find("form")
    @dialog.modal()

    @form.submit =>
      @create

  create: ->
    @post_data(@close)

  post_data: (success) ->
    form_data = @form.serializeArray()
    console.log("form_data", form_data)
    $.post("/teams", form_data, success())
    false

  close: ->
    location.href = "/teams/my"

$ ->
  form = $("#new_team_modal")
  if form.length
    new CreateTeamFormWidget(form)
