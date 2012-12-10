class SorceryCore < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :organization_name
      t.string :organization_type
      t.string :name
      t.string :phone
      t.string :email
      t.string  :time_zone
      t.string :crypted_password, :default => nil
      t.string :salt,             :default => nil

      # remember me
      t.string   :remember_me_token,               :default => nil
      t.datetime :remember_me_token_expires_at,    :default => nil

      # reset password
      t.string   :reset_password_token,            :default => nil
      t.datetime :reset_password_token_expires_at, :default => nil
      t.datetime :reset_password_email_sent_at,    :default => nil

      # activation
      t.string   :activation_state,                :default => nil
      t.string   :activation_token,                :default => nil
      t.datetime :activation_token_expires_at,     :default => nil

      # bruteforce
      t.integer  :failed_logins_count,             :default => 0
      t.datetime :lock_expires_at,         :default => nil

      # activity logging
      t.datetime :last_login_at,           :default => nil
      t.datetime :last_logout_at,          :default => nil
      t.datetime :last_activity_at,        :default => nil
      
      t.timestamps
    end

    add_index :users, :remember_me_token
    add_index :users, :reset_password_token
    add_index :users, :activation_token
    add_index :users, [:last_logout_at, :last_activity_at]
  end

  def self.down
    drop_table :users
  end
end