# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "alice#{n}@example.com" }
    name { 'Alice' }
    password { 'password' }
  end
end
