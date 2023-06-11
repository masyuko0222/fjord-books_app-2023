FactoryBot.define do
  factory :user do
    email { 'alice@example.com' }
    name { 'Alice' }
    password { 'password' }
  end
end
