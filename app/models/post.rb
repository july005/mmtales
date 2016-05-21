class Post < ActiveRecord::Base
	require 'sanitize'
	before_save :sanitize_body

	belongs_to :user

	has_attached_file :image,
    :styles => {
      :thumb => "120x120#",
      :small  => "200x200>",
      :medium => "300x300>",
      :large => "600x600>",
      :xlarge => "800x800>" },
 		default_url: "/images/missing.png"
 		validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
 
	def sanitize_body
	 	Sanitize.fragment(body, Sanitize::Config::RELAXED)
	end

end