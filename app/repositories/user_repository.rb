class UserRepository
  def self.followers(user, order_by: :desc)
    user.followers.order(created_at: order_by)
  end

  def self.following(user, order_by: :desc)
    user.following.order(created_at: order_by)
  end
end
