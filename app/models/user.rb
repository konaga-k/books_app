# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable

  has_many :active_user_follows, class_name: "UserFollow", foreign_key: :follower_id, inverse_of: :follower
  has_many :followings, through: :active_user_follows

  # 余裕があればdecoratorにしたいが、速さ優先でmodelに実装
  def full_name
    "#{last_name} #{first_name}"
  end
end
