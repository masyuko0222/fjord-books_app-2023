# frozen_string_literal: true

class Report < ApplicationRecord
  REPORT_ID_REGEXP = %r{http://localhost:3000/reports/(\d+)}

  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :sending_mentions, class_name: 'Mention', foreign_key: 'mention_from_id', dependent: :destroy, inverse_of: :mention_from
  has_many :mentioning_reports, through: :sending_mentions, source: :mention_to

  has_many :recieving_mentions, class_name: 'Mention', foreign_key: 'mention_to_id', dependent: :destroy, inverse_of: :mention_to
  has_many :mentioned_reports, through: :recieving_mentions, source: :mention_from

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def save_with_mentioning_reports
    !!(save && add_mentioning_reports)
  end

  def update_with_mentioning_reports(report_params)
    mentioning_reports.destroy_all if mentioning_reports.any?
    !!(update(report_params) && add_mentioning_reports)
  end

  def add_mentioning_reports
    Report.where(id: scan_mentioning_report_ids).each do |report|
      mentioning_reports << report
    end
  end

  def scan_mentioning_report_ids
    content.scan(REPORT_ID_REGEXP).flatten.map(&:to_i).uniq
  end
end
