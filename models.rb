 class User < ActiveRecord::Base 
 	has_many :posts
 	has_one :profile
	has_many :followers, through: :user_followers
 end

class Profile < ActiveRecord::Base
	belongs_to :user 
	has_many :posts
end

class Post < ActiveRecord::Base
	belongs_to :user
	belongs_to :profile
end

class User_Follower <ActiveRecord::Base
	belongs_to :user
	belongs_to :user_follower
end
