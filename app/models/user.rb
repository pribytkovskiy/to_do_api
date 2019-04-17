# frozen_string_literal: true

class User < ActiveRecord::Base
  has_secure_password
  has_many :projects, dependent: :destroy

  validates :email, presence: true,
                  uniqueness: { case_sensitive: false },
                  format: /@/
end
