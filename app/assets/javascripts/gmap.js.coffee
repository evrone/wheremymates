class Gmap
  constructor: ->
    @map = @renderMap()
    @mates = @renderMates()
    @detectUser()

  renderMap: ->
    myOptions =
      zoom: 6
      mapTypeId: google.maps.MapTypeId.ROADMAP
    new google.maps.Map document.getElementById("map_canvas"), myOptions

  renderMates: ->
    if window.team_mates?
      @renderMate(mate) for mate in window.team_mates
      window.team_mates
    else
      @renderMate(window.curent_user)
      [window.curent_user]

  renderMate: (mate)->
    geo = new google.maps.LatLng(mate.latitude, mate.longitude)
    mate.marker = new google.maps.Marker
      position: geo
      map: @map
      title: mate.name

  detectUser: ->
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition (position) =>
        @handleGeolocation(position)
      , => @handleNoGeolocation()
    else
      @handleNoGeolocation()

  handleGeolocation: (position)->
    pos = new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
    new google.maps.InfoWindow
      map: @map
      position: pos
      content: 'You here!'
    $.post "/user/update_geo",
      user:
        latitude: position.coords.latitude
        longitude: position.coords.longitude
    @map.setCenter(pos)


  handleNoGeolocation: ->
    @map.setCenter new google.maps.LatLng(-34.397, 150.644)

$ ->
  if $('#map_canvas').length > 0 && google?
    new Gmap
