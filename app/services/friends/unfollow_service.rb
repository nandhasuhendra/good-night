module Friends
  class UnfollowService < ApplicationService
    def initialize(user, followee)
      @user = user
      @followee = followee
    end

    def call
      ActiveRecord::Base.transaction do
        follow = FollowRepository.find_and_destroy!(@user.id, @followee.id)
        handler_success(nil)
      rescue ActiveRecord::RecordNotFound
        handler_failure(em_follow_not_found)
      end
    end
  end
end
