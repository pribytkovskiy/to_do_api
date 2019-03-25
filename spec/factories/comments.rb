# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    text { FFaker::Lorem.sentence }
  end
end
