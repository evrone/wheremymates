class MainController < ApplicationController

  def index

  end

  def index2
    @markers = User.all.to_gmaps4rails do |user, marker|
      marker.infowindow render_to_string(:partial => "/shared/infowindow", locals: { user: user})
      marker.picture({
                       picture: "http://img.brothersoft.com/icon/softimage/r/ruby-120627.jpeg",
                       width: 32,
                       height: 32
                     })
      marker.title   user.name || user.id
      marker.sidebar user.name || user.id
      marker.json({ id: user.id, foo: "bar" })
    end
  end

end
