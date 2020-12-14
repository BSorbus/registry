class CreateCboUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :cbo_users, id: :uuid do |t|
      # t.string :wso2is_userid
      t.uuid :wso2is_userid, index: true
      t.uuid :cbo_userid, index: true
      t.uuid :user_id, index: true
      t.string :email, null: false
      t.string :first_name, index: true
      t.string :last_name, index: true
      t.string :user_name
      t.boolean :csu_confirmed
      t.datetime :csu_confirmed_at
      t.string :csu_confirmed_by
      ## SAML

      t.timestamps
    end

    add_index :cbo_users, :email, unique: true
  end
end
