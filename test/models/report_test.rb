# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test '#editable?' do
    alice_report = reports(:alice_report)
    alice = alice_report.user
    bob = users(:bob)

    assert alice_report.editable?(alice)
    assert_not alice_report.editable?(bob)
  end

  test '#created_on' do
    new_year_report = reports(:reportIn20260101)

    assert_equal Date.new(2026, 1, 1), new_year_report.created_on
  end
end
