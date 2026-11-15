# frozen_string_literal: true

class ReportMention < ApplicationRecord
  belongs_to :mentioning_report, class_name: 'Report'
  belongs_to :mentioned_report, class_name: 'Report'

  validates :mentioned_report_id, uniqueness: { scope: :mentioning_report_id }
end
