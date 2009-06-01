# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_social_network_session',
  :secret      => '731af871ef6835ce7eaf2402302efd8a1131d1920eccd360128b30d29f9e8696cba6e4f5a434f475fe10be17c79e954f080d448fdfca51b5faa0dbcccf0d593a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
