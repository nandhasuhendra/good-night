module Friends
  class FollowService < ApplicationService
    def initialize(user, followee)
      @user = user
      @followee = followee
    end

    def call
      ActiveRecord::Base.transaction do
        return handler_failure(@followee.errors) if @followee.errors.any?

        existing_follow = Follow.where(following: @user, followed: @followee).lock('FOR UPDATE').last
        return handler_success(@followee) if existing_follow.present?

        follow = Follow.new(following: @user, followed: @followee)
        handler_success(follow) if follow.save!
      rescue ActiveRecord::RecordInvalid => e
        handler_failure(e.record.errors)
      end
    end
  end
end
