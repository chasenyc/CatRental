class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user_name, unique: true, presence: true
      t.string :password_digest, unique: true, presence: true
      t.string :session_token, unique: true

      t.timestamps
    end

    add_index :users, :session_token
  end
end
