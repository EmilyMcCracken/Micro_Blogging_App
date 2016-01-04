 class User < ActiveRecord::Base 
 	has_many :posts
 	has_one :profile
	has_many :followers, through: :user_followers
 end

class Profile < ActiveRecord::Base
	belongs_to :user 
end

class Post < ActiveRecord::Base
	belongs_to :user
end

class User_Follower <ActiveRecord::Base
	belongs_to :user
	belongs_to :user_follower
end

class Relationship <ActiveRecord::Base
	belongs_to :followed, class_name: 'User'
	belongs_to :follower, class_name: 'User'
end