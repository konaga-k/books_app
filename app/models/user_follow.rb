class UserFollow < ApplicationRecord
  belongs_to :following, class_name: "User"
  belongs_to :follower, class_name: "User", inverse_of: :active_user_follows

  validate :follower_is_not_equal_to_following

  private

  def follower_is_not_equal_to_following
    if follower == following
      errors.add(:base, :follower_is_equal_to_following)
    end
  end
end
