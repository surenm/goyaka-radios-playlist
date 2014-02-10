require 'pp'
require 'koala'

require './feed_fetcher'

def main
  links = FeedFetcher.fetch(ENV['FB_ACCESS_TOKEN'])
  pp links
end

main()