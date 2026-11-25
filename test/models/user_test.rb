# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test '#name_or_email' do
    alice = users(:alice)
    no_name = users(:no_name)

    assert_equal alice.name, alice.name_or_email
    assert_equal no_name.email, no_name.name_or_email
  end
end
