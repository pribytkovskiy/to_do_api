# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    name { FFaker::Name.name }
    completed { FFaker::Boolean.random }
    deadline { DateTime.now }
    position { FFaker::Random.rand(2..9) }
    project
  end

  factory :task_completed_true, parent: :task  do
    completed  { true }
  end
end
