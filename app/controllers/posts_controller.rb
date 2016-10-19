class PostsController < ApplicationController
  include AmazonSignature
  before_action :authenticate_user!, except: [:index, :show, :search]
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.all
    @contact = Contact.new
    @todays_posts = Post.all.where("created_at > ? AND created_at < ?", Time.now.beginning_of_day, Time.now.end_of_day).limit(5)
    @recent_posts = Post.all.order("created_at desc").limit(5)
    @readmore_posts = Post.all.order("created_at desc").limit(3)
    @previous_posts = Post.all.where("created_at < ?", Time.now.beginning_of_day)
    @tags = ActsAsTaggableOn::Tag.all
  end

  def show
    set_meta_tags title: @post.title,
                  site: 'Monorails and Mickey Tales',
                  reverse: true,
                  description: @post.subtitle, 
                  twitter: {
                    card: "summary",
                    site: "@disneywiz",
                    title: "Monorails and Mickey Tales",
                    description: @post.title,
                    image: @post.image.url
                  },
                  og: {
                    title:  "Monorails and Mickey Tales",
                    description: @post.title,
                    type: 'website',
                    url: post_url(@post),
                    image: @post.image.url
                  },
                  alternate: {
                    href: 'http://www.monorailsandmickeytales.com/feed.rss', type: 'application/rss+xml', title: 'RSS'
                  }
    @posts = Post.all
    @todays_posts = Post.all.where("created_at > ? AND created_at < ?", Time.now.beginning_of_day, Time.now.end_of_day)
    @recent_posts = Post.all.order("created_at desc").limit(5)
    @previous_posts = Post.all.where("created_at < ?", Time.now.beginning_of_day)
    @readmore_posts = Post.all.where.not(id: @post.id).order("created_at desc").limit(3)
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
