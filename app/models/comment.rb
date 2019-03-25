# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :task

  validates :text, presence: true, length: { minimum: 10, maximum: 256 }
end
