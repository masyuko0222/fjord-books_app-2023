# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :from_relationships, class_name: 'Mention', foreign_key: 'mention_from_id', dependent: :destroy
  has_many :to_relationships, class_name: 'Mention', foreign_key: 'mention_to_id', dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end
end
