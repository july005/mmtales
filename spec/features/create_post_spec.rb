require 'rails_helper'

feature "user creates blog post" do

 scenario "user creates a post", js: true do
	 visit new_post_path
	 fill_in "post[title]", with: Faker::Book.title
	 fill_in "post[subtitle]", with: Faker::Book.author
	 find('button[data-cmd="underline"]').click
 	 find(:css, ".fr-element.fr-view").set("This is a great post.")
	 click_button "Create Post"

	 expect(Post.count).to eq 1
	 post = Post.last
	 expect(page).to have_text(post.title)
	 expect(page).to have_selector :css, "div.fr-view"
   expect(page).to have_css("p", text: "This is a great post.")
 end

end

