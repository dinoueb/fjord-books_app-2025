class CreateUserProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :user_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :zipcode, limit: 7
      t.string :address
      t.text :description, limit: 300

      t.timestamps
    end
  end
end
