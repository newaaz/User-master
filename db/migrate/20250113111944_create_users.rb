class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :surname
      t.string :patronymic, null: false
      t.string :email, null: false, index: { unique: true }
      t.integer :age, null: false
      t.string :nationality, null: false
      t.string :country, null: false
      t.string :gender, null: false
      t.string :user_full_name, null: false

      t.timestamps
    end
  end
end
