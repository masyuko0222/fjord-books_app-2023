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
    result_to_save = false

    transaction do
      result_to_save = save && create_new_mentions # createという名だけど、booleanを返すメソッド
      raise ActiveRecord::Rollback unless result_to_save
    end

    result_to_save
  end

  def update_with_mentioning_reports(report_params)
    result_to_save = false

    transaction do
      mentioning_reports.destroy_all
      result_to_save = update(report_params) && create_new_mentions
      raise ActiveRecord::Rollback unless result_to_save
    end

    result_to_save
  end

  private

  def create_new_mentions
    new_mentions =
      fetch_mentioning_reports.each do |mentioning_report|
        new_mention = Mention.new(mention_from_id: id, mention_to_id: mentioning_report.id)
        new_mention.save
      end

    new_mentions.all?
  end

  def fetch_mentioning_reports
    scanned_ids = content.scan(REPORT_ID_REGEXP).flatten.map(&:to_i).uniq
    Report.where(id: scanned_ids)
  end
end
