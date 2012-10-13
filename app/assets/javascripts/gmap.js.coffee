class Gmap
  constructor: ->
    @map = @renderMap()
    @detectUser()

  renderMap: ->
    myOptions =
      zoom: 6
      mapTypeId: google.maps.MapTypeId.ROADMAP
    new google.maps.Map document.getElementById("map_canvas"), myOptions

  detectUser: ->
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition (position) =>
        @handleGeolocation(position)
      , => @handleNoGeolocation()
    else
      @handleNoGeolocation()

  handleGeolocation: (position)->
    pos = new google.maps.LatLng(position.coords.latitude,position.coords.longitude)
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
