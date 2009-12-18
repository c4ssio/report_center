# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_report_center_session',
  :secret      => '86463b35d25f95c3c45d036f302342b6845b9921bc024fef8dc0564156d85df3ca818bcf22e6353b3325d6f91ec7d3c562ce08c79cfeec1b824646926172a53c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
