class Gmap
  constructor: ->
    @marker_image = "http://img.brothersoft.com/icon/softimage/r/ruby-120627.jpeg"
    @map = @renderMap()
    @mates = if window.team_mates then window.team_mates else [window.current_user]
    @renderMates()
    @detectUser()

  renderMap: ->
    myOptions =
      minZoom: 2
      maxZoom: 18
      zoom: 6
      mapTypeId: google.maps.MapTypeId.ROADMAP
    new google.maps.Map document.getElementById("map_canvas"), myOptions

  renderMates: ->
    bounds = new google.maps.LatLngBounds()
    @renderMate(mate, bounds) for mate in @mates
    @map.fitBounds(bounds)

  renderMate: (mate, bounds) ->
    if mate.latitude && mate.longitude
      geo = new google.maps.LatLng(mate.latitude, mate.longitude)
      mate.marker = new google.maps.Marker
        position: geo
        map: @map
        title: mate.name
        icon: @marker_image
      bounds.extend(geo)

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

  handleNoGeolocation: ->
    @map.setCenter new google.maps.LatLng(-34.397, 150.644)

$ ->
  if $('#map_canvas').length > 0 && google?
    new Gmap
