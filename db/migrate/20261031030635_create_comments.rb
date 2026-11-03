class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.text :comment
      t.references :user, null: false, foreign_key: true
      t.belongs_to :commentable, polymorphic: true

      t.timestamps
    end
  end
end
