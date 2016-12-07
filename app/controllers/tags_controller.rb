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
                    image: "http://www.monorailsandmickeytales.com/assets/fairygirlhead-bc187813061e255e9022bb17018eb79173cc9a427286f861c99ca9169d0dc085.png"
                  },
                  og: {
                    title:  "Monorails and Mickey Tales",
                    description: @tag.name,
                    type: 'website',
       
                    image: "http://www.monorailsandmickeytales.com/assets/fairygirlhead-bc187813061e255e9022bb17018eb79173cc9a427286f861c99ca9169d0dc085.png"
                  },
                  alternate: {
                    href: 'http://www.monorailsandmickeytales.com/feed.rss', type: 'application/rss+xml', title: 'RSS'
                  }
  end

end
