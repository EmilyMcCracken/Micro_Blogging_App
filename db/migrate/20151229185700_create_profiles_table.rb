class CreateProfilesTable < ActiveRecord::Migration
  def change
  	 create_table :profiles do |t|
  		t.string :fname
  		t.string :lname
  		t.string :city
  		t.datetime :birthday
  	end
  end
end
