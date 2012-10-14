class Gmap
  constructor: ->
    @map = @renderMap()
    @bounds = new google.maps.LatLngBounds()
    @me = window.current_user || {}
    @mates = if window.team_mates then window.team_mates else []
    @renderMates()
    @renderMe()
    @fitBounds()
    @detectUser() if window.request_geo
    @markerZindex = 0
    @renderInfo()

  renderMap: ->
    myOptions =
      minZoom: 2
      maxZoom: 18
      zoom: 12
      mapTypeId: google.maps.MapTypeId.TERRAIN
    new google.maps.Map document.getElementById("map_canvas"), myOptions

  fitBounds: ->
    @map.fitBounds(@bounds)
    google.maps.event.addListenerOnce @map, 'bounds_changed', =>
      @map.setZoom(12) if @map.getZoom() > 12

  renderMates: ->
    @renderMate(mate) for mate in @mates

  renderMate: (mate) ->
    if mate.id == @me.id
      @me.in_team = mate
    else if mate.latitude && mate.longitude
      mate.geo = new google.maps.LatLng(mate.latitude, mate.longitude)
      mate.marker = new google.maps.Marker
        position: mate.geo
        map: @map
        title: mate.name
        icon: @icon(mate.avatar_url)
      @bounds.extend(mate.geo)
      @bindMate(mate)

  renderMe: ->
    if @me.latitude && @me.longitude
      @me.geo = new google.maps.LatLng(@me.latitude, @me.longitude)
      if @me.marker
        @me.marker.setPosition(@me.geo)
      else
        @me.marker = new google.maps.Marker
          position: @me.geo
          map: @map
          title: @me.name
          icon: if @me.in_team then @icon(@me.in_team.avatar_url) else null
        if @me.in_team
          @me.in_team.marker = @me.marker
          @me.in_team.geo = @me.geo
          @bindMate(@me.in_team)
      @bounds.extend(@me.geo)

  icon: (src) ->
    new google.maps.MarkerImage src, new google.maps.Size(32,32), null, null, new google.maps.Size(32,32)

  # ============ #
  renderInfo: ->
    geocoder = new google.maps.Geocoder()
    for mate in @mates
      if mate.latitude && mate.longitude
        elem = mate.elem
        geocoder.geocode {location: mate.geo}, @renderPlace.bind(elem)
        if mate.id == @me.id
        else
          if @me && @me.geo
            distance_km = Math.round(google.maps.geometry.spherical.computeDistanceBetween(@me.geo, mate.geo)/1000)
            @renderDiff(elem, distance_km)

  renderPlace: (results, status) ->
    checkPlace = (address) ->
      places_list = ['country', 'administrative_area_level_1',
                     'administrative_area_level_2', 'administrative_area_level_3']
      for component in address
        for ctype in component.types
          return component.short_name if places_list.indexOf(ctype)!=-1

    if status == google.maps.GeocoderStatus.OK
      place_name = checkPlace(results[0].address_components)
      if place_name?
        place = this.find('.place')
        place.text(place_name)

  renderDiff: (elem, distance_km) ->
    distance = elem.find('.distance')
    distance.text(distance_km)

  # ============ #
  detectUser: ->
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition (position) =>
        @handleGeolocation(position)
      , => @handleNoGeolocation()
    else
      @handleNoGeolocation()

  handleGeolocation: (position)->
    @me.latitude = position.coords.latitude
    @me.longitude = position.coords.longitude
    pos = new google.maps.LatLng(@me.latitude, @me.longitude)
    new google.maps.InfoWindow
      map: @map
      position: pos
      content: 'You here!'
    $.post "/user/update_geo",
      user:
        latitude: position.coords.latitude
        longitude: position.coords.longitude
    @renderMe()
    @fitBounds()

  handleNoGeolocation: ->
    #@map.setCenter new google.maps.LatLng(-34.397, 150.644)
    false

  # ============ #

  bindMate: (mate) ->
    elem = $('.team_user[data-id=' + mate.id + ']')
    mate.elem = elem
    elem.data(mate: mate)
    elem.addClass('present')
    elem.click ->
      marker = mate.marker
      marker.setAnimation(google.maps.Animation.BOUNCE)
      setTimeout ->
        marker.setAnimation(null)
      , 700
    elem.mouseenter ->
      @markerZindex +=1
      mate.marker.setZIndex @markerZindex

    google.maps.event.addListener mate.marker, 'mouseover', ->
      elem.addClass('highlight')
    google.maps.event.addListener mate.marker, 'mouseout', ->
      elem.removeClass('highlight')


$ ->
  if $('#map_canvas').length > 0 && google?
    new Gmap
