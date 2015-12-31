 class User < ActiveRecord::Base 
 	has_many :posts
 	has_one :profile
 	has_many :comments
	has_many :followers, through: :follows
 end

class Profile < ActiveRecord::Base
	belongs_to :user 
	has_many :posts
end

class Post < ActiveRecord::Base
	belongs_to :user
	belongs_to :profile
end

# class Comment < ActiveRecord::Base
# 	# belongs_to :user
# 	# belongs_to :post
# 	# belongs_to :comment
# 	# has_many :comments
# end

# class Follower < User
# 	has_many :users, through: :follows
# end

# class Follow < ActiveRecord::Base
# 	belongs_to :user
# 	belongs_to :follower
# end