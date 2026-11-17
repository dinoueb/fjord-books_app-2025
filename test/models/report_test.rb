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
    report = reports(:alice_report)

    assert_equal report.created_at.to_date, report.created_on
  end
end
