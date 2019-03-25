# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :project
  has_many :comments, dependent: :destroy
  acts_as_list scope: :project

  validates :name, presence: true
end
