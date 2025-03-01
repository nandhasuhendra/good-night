class UserRepository
  def self.followers(user)
    user.followers.order(created_at: :desc)
  end

  def self.following(user)
    user.following.order(created_at: :desc)
  end
end
