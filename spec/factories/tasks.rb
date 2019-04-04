# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    name { FFaker::Name.name }
    status { FFaker::Boolean.boolean }
    date { FFaker::Date.between(2.days.ago, Date.today) }
    project
  end
end
