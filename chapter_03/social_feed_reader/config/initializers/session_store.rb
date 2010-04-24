# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_social_feed_reader_session',
  :secret      => 'f212d9d152e89bb22bec8048665f133cbbbd01afa200a4340ef35eca6c33923103dc36360cdb7171c4a67efa29e8597877e86edebf4b6f445e6dca4f1bfa5fe8'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
