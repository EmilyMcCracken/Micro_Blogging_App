require 'sinatra' 
require 'sinatra/activerecord'

set :database, "sqlite3:micro_blog_db.sqlite3"

require './models'