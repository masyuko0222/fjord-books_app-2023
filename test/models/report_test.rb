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

  test 'created_on should convert created_at value to data object' do
    report = reports(:alice_report)
    report.created_at = "Fri, 26 May 2023 21:10:12.289195000 JST +09:00"

    assert_equal('Fri, 26 May 2023'.to_date, report.created_on)
  end
end
