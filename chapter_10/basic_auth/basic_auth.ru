require 'protected_app'

use Rack::Auth::Basic, "Protected Realm" do |username, password|
  # You could make a request to a user service here to see if the user is correct
  # For apps that are not externally accessible, it's sometimes easier (though not quite as secure) 
  # to just have a standard username and pass:
  username == "bobs_protection" && password = "bobs_sekret_pass"
end
run ProtectedApp.new
