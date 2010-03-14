require 'yajl'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_model'
require 'typhoeus'

$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'pauldix-ratings/version'
require 'pauldix-ratings/rating'
require 'pauldix-ratings/rating_total'
