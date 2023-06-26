# frozen_string_literal: true

FactoryBot.define do
  factory :report do
    title { 'This is my report.' }
    content { 'Did you like my report?' }
    association :user
  end
end
