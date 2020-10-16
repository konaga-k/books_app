# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable

  has_one_attached :avatar

  attribute :purge_avatar, :boolean, default: false

  def save
    ActiveRecord::Base.transaction do
      super
      avatar.purge if purge_avatar
    end
  end

  # 余裕があればdecoratorにしたいが、速さ優先でmodelに実装
  def full_name
    "#{last_name} #{first_name}"
  end
end
