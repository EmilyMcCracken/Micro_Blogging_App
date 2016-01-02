class CreateFollowersTable < ActiveRecord::Migration
  def change
  	create_table :user_followers do |t|
  		t.integer :user_id
  		t.integer :user_follower_id
  	end
  end
end
