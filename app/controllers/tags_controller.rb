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
                    image: "http://www.monorailsandmickeytales.com/assets/fairygirledit-b983cb64901e1aa7909e6c766dc442abcbc2061718cddba19ecbc5f76e42731f.png"
                  },
                  og: {
                    title:  "Monorails and Mickey Tales",
                    description: @tag.name,
                    type: 'website',
       
                    image: "http://www.monorailsandmickeytales.com/assets/fairygirledit-b983cb64901e1aa7909e6c766dc442abcbc2061718cddba19ecbc5f76e42731f.png"
                  },
                  alternate: {
                    href: 'http://www.monorailsandmickeytales.com/feed.rss', type: 'application/rss+xml', title: 'RSS'
                  }
  end

end
