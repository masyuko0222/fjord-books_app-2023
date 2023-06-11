# frozen_string_literal: true

FactoryBot.define do
  factory :report do
    title { 'Test Title' }
    content { 'Test Content' }
    association :user
  end
end
