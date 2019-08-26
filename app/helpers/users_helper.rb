module UsersHelper
  def gravatar_for user, size: Settings.helper.size
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def user_unfollow id
    current_user.active_relationships.find_by(followed_id: id)
  end

  def user_follow
    current_user.active_relationships.build
  end
end
