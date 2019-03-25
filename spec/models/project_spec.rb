# frozen_string_literal: true

RSpec.describe Project, type: :model do
  subject(:project) { FactoryBot.build :project }

  context 'db columns' do
    it { have_db_column(:name).of_type(:string) }
  end

  context 'validations' do
    it { validate_presence_of(:name) }
    it { validate_uniqueness_of(:name).case_insensitive }
  end

  context 'associations' do
    it { belong_to(:user) }
    it { have_many(:tasks) }
  end
end
