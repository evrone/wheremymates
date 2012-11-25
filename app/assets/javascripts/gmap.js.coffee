(($) ->
  class window.Gmap
    constructor: ->
      @initMap()
      @initClusterer()
      @me = window.current_user || {}
      @mates = if window.team_mates then window.team_mates else []
      @renderMates()
      @renderMe()
      @fitBounds()
      @bindTeam()
      @detectUser() if window.request_geo
      @renderInfo()

    initMap: ->
      myOptions =
        minZoom: 2
        maxZoom: 18
        zoom: 6
        mapTypeId: google.maps.MapTypeId.TERRAIN
        center: new google.maps.LatLng(52.0836, 23.6886)
      @map = new google.maps.Map document.getElementById("map_canvas"), myOptions
      @bounds = new google.maps.LatLngBounds()
      @markerZindex = 0

    initClusterer: ->
      @clusterer = new MarkerClusterer @map, [],
        styles: [
          height: 52
          width: 53
          url: '/assets/c1.png'
          textColor: 'white'
        ]
      google.maps.event.addListener @clusterer, 'mouseover', (cluster) =>
        if cluster.info
          if cluster.toid
            clearTimeout(cluster.toid)
            cluster.toid = null
          return
        cluster_info = $('<div></div>').addClass('mates_popup')

        for marker in cluster.getMarkers()
          container = $('<div></div>').addClass('mate_info').appendTo cluster_info
          container.append("<div class='mate_image'><img src='#{marker.mate.avatar_url}' /></div>")
          container.append("<span>#{marker.mate.name}</span>")
        cluster.info = new google.maps.InfoWindow
          map: @map
          position: cluster.getCenter()
          content: cluster_info.get(0)
      google.maps.event.addListener @clusterer, 'mouseout', (cluster) =>
        if cluster.info
          cluster.toid = setTimeout ->
            cluster.info.close()
            cluster.info = null
          , 1000
      google.maps.event.addListener @clusterer, 'click', (cluster) =>
        cluster.info.close() if cluster.info

    fitBounds: ->
      return if @bounds.isEmpty()
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
          icon: @icon(mate.avatar_url)
        mate.marker.mate = mate
        @clusterer.addMarker mate.marker
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
            icon: if @me.in_team then @icon(@me.in_team.avatar_url) else null
          if @me.in_team
            @me.in_team.marker = @me.marker
            @clusterer.addMarker @me.marker
            @me.marker.mate = @me.in_team
            @me.in_team.geo = @me.geo
            @bindMate(@me.in_team)
        @bounds.extend(@me.geo)

    icon: (src) ->
      new google.maps.MarkerImage src, new google.maps.Size(32,32), null, null, new google.maps.Size(32,32)

    # ============ #
    renderInfo: ->
      @geocoder = new google.maps.Geocoder()
      @geocodeQueue = []
      n = 0
      for mate in @mates
        if mate.latitude && mate.longitude
          elem = mate.elem
          if n > 1
            @geocodeQueue.push(mate)
          else
            @geocodeMate(mate)
          n++
          if mate.id == @me.id
          else
            if @me && @me.geo
              distance_km = Math.round(google.maps.geometry.spherical.computeDistanceBetween(@me.geo, mate.geo)/1000)
              @renderDiff(elem, distance_km)

    geocodeMate: (mate) ->
      @geocoder.geocode {location: mate.geo}, @renderPlace.bind(this, mate)

    renderPlace: (mate, results, status) ->
      if status == google.maps.GeocoderStatus.OK
        place_name = @checkPlace(results[0].address_components)
        if place_name?
          place = mate.elem.find('.place')
          place.text(place_name)
      if nextmate = @geocodeQueue.pop()
        setTimeout =>
          @geocodeMate(nextmate)
        , 1000


    checkPlace: (address) ->
      places_list = ['country', 'administrative_area_level_1',
                     'administrative_area_level_2', 'administrative_area_level_3']
      for component in address
        for ctype in component.types
          return component.short_name if places_list.indexOf(ctype)!=-1 && component.short_name != ''

    renderDiff: (elem, distance_km) ->
      distance = elem.find('.distance')
      distance.text("#{distance_km} km")

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
        content: 'You are here!'
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
      elem.click =>
        marker = mate.marker
        if cluster = @findInCluster(marker)
          google.maps.event.trigger @clusterer, 'mouseover', cluster
        else if @map.getBounds().contains(mate.geo)
          marker.setAnimation(google.maps.Animation.BOUNCE)
          setTimeout ->
            marker.setAnimation(null)
          , 700
        else
          @map.panTo mate.geo
      elem.find('.distance').mouseenter =>
        if cluster = @findInCluster(@me.marker)
          source = cluster.getCenter()
        else
          source = @me.geo
        if cluster = @findInCluster(mate.marker)
          target = cluster.getCenter()
        else
          target = mate.geo
        @distancePoly().setPath [source, target]
        @distancePoly().setVisible(true)
      elem.find('.distance').mouseleave =>
        @distancePoly().setVisible(false)
      elem.mouseenter ->
        @markerZindex +=1
        mate.marker.setZIndex @markerZindex

      google.maps.event.addListener mate.marker, 'mouseover', ->
        if mate.marker.info
          if mate.marker.toid
            clearTimeout(mate.marker.toid)
            mate.marker.toid = null
          return
        marker_info = $('<div></div>').addClass('mates_popup')
        container = $('<div></div>').addClass('mate_info').appendTo marker_info
        container.append("<div class='mate_image'><img src='#{mate.avatar_url}' /></div>")
        container.append("<span>#{mate.name}</span>")

        mate.marker.info = new google.maps.InfoWindow
          map: @map
          position: mate.marker.getPosition()
          content: marker_info.get(0)
      google.maps.event.addListener mate.marker, 'mouseout', ->
        if mate.marker.info
          mate.marker.toid = setTimeout ->
            mate.marker.info.close()
            mate.marker.info = null
          , 1000

    findInCluster: (marker) ->
      for cluster in @clusterer.getClusters()
        return cluster if cluster.getSize() > 1 && cluster.getMarkers().indexOf(marker)!=-1

    distancePoly: ->
      @distancePolyline ||= new google.maps.Polyline
        clickable: false
        geodesic: true
        strokeColor: '#CC0000'
        strokeOpacity: 0.8
        strokeWeight: 3
        map: @map
        visible: false

    bindTeam: ->
      elem = $(".team_name")
      elem.click => @fitBounds()

)(wmm_jQuery || jQuery)
