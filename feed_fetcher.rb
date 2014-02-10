class FeedFetcher
  @@GOYAKA_RADIOS_GROUP_ID = 187054981393266
  @@PER_PAGE = 10

  attr_reader :feed, :links

  def initialize(access_token)
    @access_token = access_token
    @graph = Koala::Facebook::API.new(@access_token)
    @feed = @graph.get_connections(@@GOYAKA_RADIOS_GROUP_ID, "feed", :limit => @@PER_PAGE)
    @links = Set.new
  end

  def has_more_pages?
    not @feed.next_page.nil?
  end

  def get_next_page
    @feed = @feed.next_page
  end

  def process_feed_data
    @feed.each do |post|
        if not post["link"].nil?
          @links.add(post["link"])
        end
    end
  end


  def self.fetch(access_token, max_posts = 100)
    @fetcher = FeedFetcher.new(access_token)

    while true
      if @fetcher.has_more_pages?
        @fetcher.get_next_page()
        @fetcher.process_feed_data()
      else
        break
      end

      return @fetcher.links if @fetcher.links.size > max_posts
    end
  end
end