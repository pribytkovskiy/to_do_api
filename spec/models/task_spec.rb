# frozen_string_literal: true

RSpec.describe Task, type: :model do
  subject(:task) { FactoryBot.build :task }

  context 'db columns' do
    it { have_db_column(:name).of_type(:string) }
    it { have_db_column(:deadline).of_type(:datetime) }
    it { have_db_column(:position).of_type(:integer) }
    it { have_db_column(:completed).of_type(:boolean) }
  end

  context 'validations' do
    it { validate_presence_of(:name) }
  end

  context 'associations' do
    it { belong_to(:task) }
  end
end
