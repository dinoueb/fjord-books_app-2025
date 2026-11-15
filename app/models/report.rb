# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :passive_mentions, class_name: 'ReportMention', foreign_key: 'mentioned_report_id', dependent: :destroy, inverse_of: :mentioned_report
  has_many :mentioned_reports, through: :passive_mentions, source: :mentioning_report

  has_many :active_mentions, class_name: 'ReportMention', foreign_key: 'mentioning_report_id', dependent: :destroy, inverse_of: :mentioning_report
  has_many :mentioning_reports, through: :active_mentions, source: :mentioned_report

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def save_with_mentions
    return false if invalid?

    transaction do
      save!
      self.mentioning_report_ids = mention_ids
    end

    true
  end

  def update_with_mentions(report_params)
    return false if invalid?

    transaction do
      update!(report_params)
      self.mentioning_report_ids = mention_ids
    end

    true
  end

  private

  def mention_ids
    ids = content.scan(%r{http://localhost:3000/reports/(\d+)})
                 .flatten
                 .uniq
                 .reject { |mention_id| mention_id.to_i == id }
    Report.where(id: ids).ids
  end
end
