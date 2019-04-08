# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    name { FFaker::Name.name }
    completed { FFaker::Boolean.boolean }
    deadline { FFaker::Date.between(2.days.ago, Date.today) }
    position
    project
  end
end
