# frozen_string_literal: true

class BookComment < ApplicationRecord
  belongs_to :user
  belongs_to :book, inverse_of: "comments"

  validates :body, presence: true
end
