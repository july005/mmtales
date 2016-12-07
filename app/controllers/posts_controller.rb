class PostsController < ApplicationController
  include AmazonSignature
  before_action :authenticate_user!, except: [:index, :show, :search]
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.all
    @contact = Contact.new
    @todays_posts = Post.all.where("created_at > ? AND created_at < ?", Time.now.beginning_of_day, Time.now.end_of_day).limit(5)
    @recent_posts = Post.all.order('created_at DESC').limit(3)
    @previous_posts = Post.all.where("created_at < ?", Time.now.beginning_of_day)
    @allbut_posts = Post.all.order("created_at desc")
 
    @prevone_posts = Post.all.where("created_at < ?", Time.now.beginning_of_day).limit(1)
    @prevtwo_posts = Post.all.where("created_at < ?", Time.now.beginning_of_day).limit(1).offset(1)
    @prevthree_posts = Post.all.where("created_at < ?", Time.now.beginning_of_day).limit(1).offset(2)
    @prevfour_posts = Post.all.where("created_at < ?", Time.now.beginning_of_day).limit(1).offset(3)
    @prevfive_posts = Post.all.where("created_at < ?", Time.now.beginning_of_day).limit(1).offset(4)
    @prevsix_posts = Post.all.where("created_at < ?", Time.now.beginning_of_day).limit(1).offset(5)

    @tags = ActsAsTaggableOn::Tag.all
    
    @resorts_posts = Post.tagged_with("Resorts").order("created_at DESC")
    @parks_posts = Post.tagged_with("Parks").order("created_at DESC")
    @dining_posts = Post.tagged_with("Dining").order("created_at DESC")
    @transport_posts = Post.tagged_with("Transport").order("created_at DESC")
    @shopping_posts = Post.tagged_with("Shopping").order("created_at DESC")
    @budgets_posts = Post.tagged_with("Budgets").order("created_at DESC")
    @page_title = "monorails & mickey tales"
  end

  def show
    set_meta_tags title: @post.title,
                  site: 'Monorails and Mickey Tales',
                  reverse: true,
                  description: @post.body, 
                  keywords: %w[Disney World Trip Planning Save Money Monorails Mickey Tales Travel Tips Hotels Parks Resorts Dining Walt],
                  twitter: {
                    card: "summary",
                    site: "@disneywiz",
                    title: "monorails & mickey tales",
                    description: @post.title,
                    image: "http://www.monorailsandmickeytales.com/assets/fairygirledit-cba4cb402f117b750075be61942326af00be0f915f51108beb403f460f64cb14.png"
                  },
                  og: {
                    title:  "monorails & mickey tales",
                    description: @post.title,
                    type: 'website',
                    url: post_url(@post),
                    image: "http://www.monorailsandmickeytales.com/assets/fairygirledit-cba4cb402f117b750075be61942326af00be0f915f51108beb403f460f64cb14.png"
                  },
                  alternate: {
                    href: 'http://www.monorailsandmickeytales.com/feed.rss', type: 'application/rss+xml', title: 'RSS'
                  }
    @posts = Post.all
    @todays_posts = Post.all.where("created_at > ? AND created_at < ?", Time.now.beginning_of_day, Time.now.end_of_day)
    @recent_posts = Post.all.order('created_at DESC').limit(3)
    @previous_posts = Post.all.where("created_at < ?", Time.now.beginning_of_day)
    @readmore_posts = Post.all.where.not(id: @post.id).order("created_at DESC").limit(5)
    @allbut_posts = Post.all.order("created_at DESC")

  end

  def search
    if params[:query].present?
      @posts = Post.search_title(params[:query])
    else
      @posts = Post.all
    end
  end

  def new
    @hash = AmazonSignature::data_hash
    @post = current_user.posts.build
    @contact = Contact.new
  end

  def edit
    @hash = AmazonSignature::data_hash
  end

  def create
    @hash = AmazonSignature::data_hash
    @post = current_user.posts.build(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
    
    @contact = Contact.new(params[:contact])
    @contact.request = request
    if @contact.deliver
      flash.now[:error] = nil
    else
      flash.now[:error] = "Oops! Looks like there was a bump in the road. Let's try this again."
    end

  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :subtitle, :body, :image, :user_id, :tag_list)
    end
end
