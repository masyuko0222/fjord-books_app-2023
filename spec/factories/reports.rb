# frozen_string_literal: true

FactoryBot.define do
  factory :report do
    sequence(:title) { |n| "Test title#{n}" }
    sequence(:content) { |n| "Test content#{n}" }
    created_at { Time.zone.now }
    association :user

    trait :report_mentioning_id_2_and_3 do
      content { 'http://localhost:3000/reports/2 is bad. http://localhost:3000/reports/3 is good!' }
    end

    trait :report_mentioning_id_2_and_3_with_abnormal_ids do
      content { 'http://localhost:3000/reports/2 is bad. http://localhost:3000/reports/3 is good! http://localhost:3000/reports/ijou is string. http://localhost:3000/reports/７７７ is zenkaku. http://localhost:3000/reports/#{Report.last.id + 100} is not exist.' }
    end

    trait :report_mentioning_reportself do
      id { 100 }
      content { 'http://localhost:3000/reports/2 is bad. http://localhost:3000/reports/3 is good! http://localhost:3000/reports/100 is me.' }
    end
  end
end
