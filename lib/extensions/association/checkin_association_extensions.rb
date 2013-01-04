module CheckinAssociationExtensions
  def create_for_foursquare(data)
    return if data.blank?
    data.map do |item|
      begin
        where(uid: item.id, user_id: account.user_id).first_or_create do |checkin|
          location = item.venue.location
          checkin.latitude = location.lat
          checkin.longitude = location.lng
          checkin.checked_at = Time.at item.createdAt
          checkin.place = [location.city, location.country].reject(&:blank?).join(', ')
          checkin.desc = item.shout || item.venue.name
          checkin.link = item.venue.canonicalUrl
        end
      rescue
        false
      end
    end
  end

  def create_for_facebook(data)
    return if data.blank?
    data.map do |post|
      begin
        post = Hashie::Mash.new(post)
        where(uid: post.id, user_id: account.user_id).first_or_create do |checkin|
          location = post.place.location
          checkin.latitude = location.latitude
          checkin.longitude = location.longitude
          checkin.checked_at = post.created_time
          checkin.place = [location.city, location.country].reject(&:blank?).join(', ')
          checkin.desc = post.story
          checkin.link = post.actions.first.link
        end
      rescue
        false
      end
    end
  end

  def account
    proxy_association.owner
  end
end
