class TagsController < ApplicationController
  def index
    @tags = ActsAsTaggableOn::Tag.all
  end

  def show
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    @posts = Post.tagged_with(@tag.name)
    set_meta_tags title: @tag.name,
                  site: 'monorails & mickey tales',
                  reverse: true,
                  description: 'The best unbiased Disney trip advice', 
                  keywords: %w[Disney World Trip Planning Save Money Monorails Mickey Tales Travel Tips Hotels Parks Resorts Dining Walt],
                  twitter: {
                    card: "summary",
                    site: "@monorails & mickey tales",
                    description: 'The best unbiased Disney trip advice',
                    image: "fairygirlhead.jpg"
                  },
                  og: {
                    title:  "Monorails and Mickey Tales",
                    description: @tag.name,
                    type: 'website',
       
                    image: "fairygirlhead.jpg"
                  },
                  alternate: {
                    href: 'http://www.monorailsandmickeytales.com/feed.rss', type: 'application/rss+xml', title: 'RSS'
                  }
  end

end
