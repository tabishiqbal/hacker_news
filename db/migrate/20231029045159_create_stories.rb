class CreateStories < ActiveRecord::Migration[7.1]
  def change
    create_table :stories do |t|
      t.string :title, null: false
      t.string :url
      t.string :by
      t.integer :hn_id, null: false, index: { unique: true }
      t.integer :score
      t.integer :time
      t.string :kids, array: true, default: []

      t.timestamps
    end
  end
end
