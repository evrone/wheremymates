module TeamsHelper
  def userdata_hash
    {:only => [:id, :name], :methods => [:avatar_url, :latitude, :longitude, :place]}
  end
end
