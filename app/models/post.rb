class Post < ActiveRecord::Base
 require 'sanitize'
 before_save :sanitize_body
 belongs_to :user
 
 def sanitize_body
 	Sanitize.fragment(body, Sanitize::Config::RELAXED)
 end

end