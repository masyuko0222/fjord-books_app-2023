# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test 'editable? should return true if current user is writer of the report' do
    report = reports(:alice_report) 
    target_user = users(:alice)

    assert(report.editable?(target_user))
  end

  test 'editable? should return false if current user is not writer of the report' do
    report = reports(:bob_report) 
    target_user = users(:alice)

    assert_not(report.editable?(target_user))
  end
end
