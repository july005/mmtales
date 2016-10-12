class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :prepare_meta_tags, if: "request.get?"

  def prepare_meta_tags(options={})
    site_name   = "Monorails and Mickey Tales"
    title       = [controller_name, action_name].join(" ")
    description = "Unbiased Walt Disney World advice"
    image       = options[:image] || "https://a.disquscdn.com/uploads/users/22626/7036/avatar92.jpg?1476287188"
    current_url = request.url

    # Let's prepare a nice set of defaults
    defaults = {
      site:        site_name,
      title:       title,
      image:       image,
      description: description,
      keywords:    %w[web software development mobile app],
      twitter: {
        site_name: site_name,
        site: '@MonorailsandMickeyTales',
        card: 'summary',
        description: description,
        image: image
      },
      og: {
        url: current_url,
        site_name: site_name,
        title: title,
        image: image,
        description: description,
        type: 'website'
      }
    }

    options.reverse_merge!(defaults)

    set_meta_tags options
  end


end
