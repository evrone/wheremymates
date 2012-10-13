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
        pos = new google.maps.LatLng(position.coords.latitude,position.coords.longitude)
        new google.maps.InfoWindow
          map: @map
          position: pos
          content: 'You here!'
        @map.setCenter(pos)
      , => @handleNoGeolocation()
    else
      @handleNoGeolocation()

  handleNoGeolocation: ->
    alert("Geolocation service failed.")
    @map.setCenter new google.maps.LatLng(-34.397, 150.644)


$ ->
  if $('#map_canvas').length > 0 && google?
    new Gmap
