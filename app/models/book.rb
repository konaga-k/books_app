# frozen_string_literal: true

class Book < ApplicationRecord
  has_many :comments, class_name: "BookComment", dependent: :destroy

  mount_uploader :picture, PictureUploader
end
