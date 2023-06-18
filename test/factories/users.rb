# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "alice#{n}@example.com" }
    name { 'Alice' }
    password { 'password' }

    factory :another_user do
      email { 'bob@example.com' }
      name { 'Bob' }
    end
  end
end
