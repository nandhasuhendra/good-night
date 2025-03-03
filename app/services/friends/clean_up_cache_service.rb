module Friends
  class CleanUpCacheService < ApplicationService
    def initialize(user)
      @user = user
    end

    def call
      Rails.cache.delete_matched("user_#{@user.id}_followers")
      Rails.cache.delete_matched("user_#{@user.id}_following")
    end
  end
end

