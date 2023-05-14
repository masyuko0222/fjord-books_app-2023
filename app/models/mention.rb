# frozen_string_literal: true

class Mention < ApplicationRecord
  belongs_to :mention_from, class_name: 'Report', inverse_of: :from_relationships
  belongs_to :mention_to, class_name: 'Report', inverse_of: :to_relationships
  validates :mention_from, presence: true
  validates :mention_to, presence: true
end
