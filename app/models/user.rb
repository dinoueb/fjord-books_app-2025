# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :icon do |attachable|
    attachable.variant :thumb, resize_and_pad: [100, 100]
  end

  validate :icon_content_type

  private

  def icon_content_type
    return unless icon.attached?

    file_extensions = %w[image/png image/jpg image/jpeg]
    errors.add(:icon, :wrong_extension) unless icon.content_type.in?(file_extensions)
  end
end
