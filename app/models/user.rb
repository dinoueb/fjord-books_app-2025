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

    allowed_content_types = %w[image/jpeg image/png image/gif]
    errors.add(:icon, :wrong_image_types, image_types: 'JPEG・PNG・GIF') unless icon.content_type.in?(allowed_content_types)
  end
end
