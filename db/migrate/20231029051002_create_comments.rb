class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.references :story, null: false, foreign_key: true
      t.text :body
      t.string :by
      t.integer :time
      t.integer :hn_id, null: false
      t.integer :parent

      t.timestamps
    end
  end
end
