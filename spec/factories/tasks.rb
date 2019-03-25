# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    name { Faker::Name.name }
    status { Faker::Boolean.boolean }
    date { Faker::Date.between(2.days.ago, Date.today) }
    project
  end
end
