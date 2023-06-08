# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "tester#{n}@example.com" }
    name { 'Alice' }
    password { 'password' }
    password_confirmation { 'password' }

    trait :user_without_name do
      name { nil }
    end

    trait :other_user do
      email { 'otheruser@example.com' }
      name { 'Bob' }
    end
  end
end
