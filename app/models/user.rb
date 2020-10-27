# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable
  devise :omniauthable, omniauth_providers: %i[github]

  has_one_attached :avatar

  attribute :purge_avatar, :boolean, default: false

  class << self
    def from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]
        user.last_name = auth.info.last_name
        user.first_name = auth.info.first_name
      end
    end
  end

  def save
    ActiveRecord::Base.transaction do
      super
      avatar.purge if purge_avatar
    end
  end

  has_many :active_user_follows, class_name: "UserFollow", foreign_key: :follower_id, inverse_of: :follower
  has_many :followings, through: :active_user_follows

  # 余裕があればdecoratorにしたいが、速さ優先でmodelに実装
  def full_name
    "#{last_name} #{first_name}"
  end
end
