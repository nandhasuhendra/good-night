class FollowRepository
  def self.find_existing_follow_with_lock(user_id, followee_id)
    Follow.where(following_id: user_id, followed_id: followee_id).lock('FOR UPDATE').last
  end

  def self.find_and_destroy!(user_id, followee_id)
    follow = Follow.find_by!(following_id: user_id, followed_id: followee_id)
    follow.destroy! if follow.present?
  end
end
