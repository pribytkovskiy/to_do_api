# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    name { FFaker::Lorem.sentence }
  end
end
