require 'rails_helper'

RSpec.describe Post, type: :model do
 describe "#sanitize_body" do
 	it "sanitizes the post's body with a relaxed sanitation" do
 		post = Post.new(
 		body: "<p><b>Good html</b></p><script
 			src='http://mallorysevilsite.com/authstealer.js'>"
 )
 		expect(post.sanitize_body).to eq "<p><b>Good html</b></p>"
 	end
 end
end
