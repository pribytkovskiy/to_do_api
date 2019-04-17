# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :task

  mount_uploader :image, ImageUploader

  TEXT_LENGTH_RANGE = (10..256).freeze
  FILE_SIZE = 10.megabytes

  validates :text, presence: true, length: { in: TEXT_LENGTH_RANGE }
  validates_size_of :image, maximum: FILE_SIZE, message: I18n.t('file')
end
