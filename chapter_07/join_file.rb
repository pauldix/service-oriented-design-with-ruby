require 'rubygems'
require 'pauldix-entries/lib/pauldix-entries'
require 'pauldix-ratings/lib/pauldix-ratings'
require 'pauldix-reading-list/lib/pauldix-reading-list'

# this would go in a service initalizer in config/initializers/
HYDRA = Typhoeus::Hydra.new
PauldixEntries::Config.hydra = HYDRA
PauldixRatings::Config.hydra = HYDRA
PauldixReadingList::Config.hydra = HYDRA

# in config/environments/production.rb you'd have to set a host
host = "localhost:3000"
PauldixEntries::Config.host = host
PauldixRatings::Config.host = host
PauldixReadingList::Config.host = host
bunny_client = Bunny.new(:host => "localhost")
#bunny_client.start
PauldixRatings::Config.bunny_client = bunny_client

# these calls would go in config/environments/development.rb
# and /config/environments/test.rb to avoid hitting the real servers.
entry_ids = %w[entry1 entry2 entry3]
PauldixEntries::Entry.stub_all_ids(entry_ids)
PauldixRatings::RatingTotal.stub_all_ids(entry_ids)
PauldixReadingList::ReadingList.stub_all_user_ids_with_ids(
  ["paul"], entry_ids)


# and here is code that would be in a presenter or a 
# non-ActiveRecord model
reading_list = nil

PauldixReadingList::ReadingList.for_user("paul", 
  :include => [:entry, :rating_total]) do |list|

  reading_list = list
end

HYDRA.run

# now we can access the reading list
reading_list.entries.each do |entry|
  puts entry.id
  puts entry.title
  puts entry.body
  puts "up: #{entry.rating_total.up_count} | down: #{entry.rating_total.down_count}\n\n"
end

# posting a rating
rating = Rating.new(:user_id => "paul", :entry_id => "entry1", :vote => "up")
