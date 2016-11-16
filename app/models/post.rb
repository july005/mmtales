class Post < ActiveRecord::Base
	require 'sanitize'
	include PgSearch
	pg_search_scope :search_title, :against => [:title, :subtitle, :body]


	before_save :sanitize_body
	belongs_to :user
	

	has_attached_file :image,
		storage: :s3,
		s3_credentials: {
			access_key_id: ENV["aws_access_key_id"],
			secret_access_key: ENV["aws_secret_access_key"],
			bucket: ENV["bucket"]
		},
		#path: " ",
		#url: " ",
    :styles => {
      :thumb => "120x120#",
      :small  => "200x200>",
      :medium => "300x300>",
      :large => "600x600>",
      :xlarge => "800x800>" },
 		default_url: "/images/missing.png",
 		s3_region: ENV["aws_region"]
 		
 		validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

 		acts_as_taggable_on :tags
 
	def sanitize_body
	 	Sanitize.fragment(body, Sanitize::Config::RELAXED)
	end

	def relatedposts
    post_array = []
    self.tags.each do |tag|
      post_array < @post.tags
    end
    post_array.uniq.delete(self)
  end

end