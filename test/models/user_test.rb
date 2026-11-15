# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test '#name_or_email' do
    alice = users(:alice)

    assert_equal alice.name, alice.name_or_email
  end
end
