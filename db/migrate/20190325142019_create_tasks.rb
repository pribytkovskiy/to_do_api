class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :name
      t.integer :position
      t.boolean :completed, default: false
      t.datetime :deadline
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
