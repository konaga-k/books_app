# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable
  devise :omniauthable, omniauth_providers: %i[github]

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

  # 余裕があればdecoratorにしたいが、速さ優先でmodelに実装
  def full_name
    "#{last_name} #{first_name}"
  end
end
