# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test '#editable?' do
    alice_report = reports(:alice_report)
    alice = users(:alice)

    assert alice_report.editable?(alice)
  end

  test '#created_on' do
    alice_report = reports(:alice_report)

    assert_equal alice_report.created_at.to_date, alice_report.created_on
  end
end
