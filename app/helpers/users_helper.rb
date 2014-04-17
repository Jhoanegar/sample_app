module UsersHelper
  # Returns the gravatar of the user
  def gravatar_for(user,options={})
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    opt = options.merge(alt:user.name, class: "gravatar")
    image_tag(gravatar_url , opt)
    
  end
end
