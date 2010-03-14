require 'rubygems'
require 'pauldix-entries/lib/pauldix-entries'
require 'pauldix-ratings/lib/pauldix-ratings'
require 'pauldix-reading-list/lib/pauldix-reading-list'
include PauldixEntries
include PauldixRatings
include PauldixReadingList

# this would go in a service initalizer in config/initializers/
hydra = Typhoeus::Hydra.new
Entry.hydra = hydra
RatingTotal.hydra = hydra
ReadingList.hydra = hydra

# these calls would go in config/environments/development.rb
# and /config/environments/test.rb to avoid hitting the real servers.
entry_ids = %w[entry1 entry2 entry3]
Entry.stub_all_ids(entry_ids)
RatingTotal.stub_all_ids(entry_ids)
ReadingList.stub_all_emails_with_ids(["paul@pauldix.net"], entry_ids)

# and here is code that would be in a presenter or a 
# non-ActiveRecord model
reading_list = nil

ReadingList.for_user_by_email("paul@pauldix.net", :include => [:entry, :rating_total]) do |list|
  reading_list = list
end

hydra.run

# now we can access the reading list
reading_list.entries.each do |entry|
  puts entry.id
  puts entry.title
  puts entry.body
  puts "up: #{entry.rating_total.up_count} | down: #{entry.rating_total.down_count}\n\n"
end
