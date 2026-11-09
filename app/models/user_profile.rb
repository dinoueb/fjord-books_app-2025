# frozen_string_literal: true

class UserProfile < ApplicationRecord
  belongs_to :user

  validates :zipcode, length: { is: 7 }, allow_blank: true
  validates :description, length: { maximum: 300 }
end
