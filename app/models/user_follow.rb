# frozen_string_literal: true

class UserFollow < ApplicationRecord
  belongs_to :following, class_name: "User"
  belongs_to :follower, class_name: "User", inverse_of: :active_user_follows

  validate :follower_cannot_be_equal_to_following

  private
    def follower_cannot_be_equal_to_following
      if follower == following
        errors.add(:base, :follower_cannot_be_equal_to_following)
      end
    end
end
