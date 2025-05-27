FactoryBot.define do
  factory :user do
    username { Faker::Internet.unique.username }
    password { "validpassword123" }
    password_confirmation { "validpassword123" }
  end
end
