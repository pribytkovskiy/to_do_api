# frozen_string_literal: true

RSpec.describe Comment, type: :model do
  context 'db columns' do
    it { is_expected.to have_db_column(:text).of_type(:text) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:text) }
    it { is_expected.to validate_length_of(:text).is_at_least(10) }
    it { is_expected.to validate_length_of(:text).is_at_most(256) }
  end

  context 'associations' do
    it { belong_to(:project) }
    it { have_many(:comments) }
  end
end
