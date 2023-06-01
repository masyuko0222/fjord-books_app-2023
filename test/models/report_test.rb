# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  setup do
    @report = reports(:alice_report)
  end

  test 'editable? should return true if current user is writer of the report' do
    target_user = users(:alice)

    assert(@report.editable?(target_user))
  end

  test 'editable? should return false if current user is not writer of the report' do
    report = reports(:bob_report) 
    target_user = users(:alice)

    assert_not(report.editable?(target_user))
  end

  test 'created_on should convert created_at value to data object' do
    @report.created_at = "Fri, 26 May 2023 21:10:12.289195000 JST +09:00"

    assert_equal('Fri, 26 May 2023'.to_date, @report.created_on)
  end

  test 'save_mentions should save new mentions scanned from report content without own id' do
    mention_regexp = %r{http://localhost:3000/reports/(\d+)}

    @report.content = "http://localhost:3000/reports/2 is good. http://localhost:3000/reports/aaa is normal."

    @report.send(:save_mentions)

    assert_equal([2], @report.mentioning_report_ids)

    @report.content = "I am http://localhost:3000/reports/#{@report.id}. http://localhost:3000/reports/2 is good. http://localhost:3000/reports/3 is normal. http://localhost:3000/reports/4 is bad."

    @report.send(:save_mentions)

    assert_equal([2,3,4], @report.mentioning_report_ids)
  end
end
