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
    Report.transaction do
      save!
      save_mentioning_reports
    end
  end

  def update_with_mentioning_reports(report_params)
    Report.transaction do
      mentioning_reports.destroy_all
      update!(report_params)
      save_mentioning_reports
    end
  end

  def save_mentioning_reports
    new_mentioning_reports = Report.where(id: scan_mentioning_report_ids)

    mentioning_reports.concat(new_mentioning_reports)
  end

  def scan_mentioning_report_ids
    content.scan(REPORT_ID_REGEXP).flatten.map(&:to_i).uniq
  end
end
