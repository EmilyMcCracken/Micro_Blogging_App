 class User < ActiveRecord::Base   
 	has_many :posts
 	has_one :profile
 end

class Profile < ActiveRecord::Base
	belongs_to :user 
	has_many :posts
end

class Post < ActiveRecord::Base
	belongs_to :user
	belongs_to :profile
end
