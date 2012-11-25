window.team = <%== current_team.as_json(:only => [:id, :name]).to_json %>
window.team_mates = <%== current_team.users.as_json(:only => [:id, :name, :latitude, :longitude], :methods => :avatar_url).to_json %>

document.write '<%= stylesheet_link_tag stylesheet_url("gmap") %>'

unless jQuery?  # TODO: Add version checking, it must be >= 1.7
  document.write '<%= javascript_include_tag javascript_url("jquery") %>'
  document.write """
    <script>
    wmm_jQuery = jQuery.noConflict(true);
    </script>
  """

document.write '<%= javascript_include_tag javascript_url("gmap"), javascript_url("markerclusterer") %>'
document.write '<%= javascript_include_tag "https://maps.google.com/maps/api/js?sensor=true&libraries=geometry" %>'
document.write """
  <script>
  (function($) {
    $(function() {
      if ($('#map_canvas').length > 0 && (typeof google !== 'undefined' && google !== null)) {
        return new Gmap;
      }
    });
  })(typeof wmm_jQuery !== 'undefined' && wmm_jQuery !== null ? wmm_jQuery : jQuery);
  </script>
"""
