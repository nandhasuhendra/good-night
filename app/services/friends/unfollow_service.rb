module Friends
  class UnfollowService < ApplicationService
    def initialize(user, followee)
      @user = user
      @followee = followee
    end

    def call
      ActiveRecord::Base.transaction do
        follow = Follow.find_by!(following_id: @user.id, followed_id: @followee.id)
        follow.destroy!
        handler_success(nil)
      rescue ActiveRecord::RecordNotFound
        handler_failure(en_follow_not_found)
      end
    end
  end
end
