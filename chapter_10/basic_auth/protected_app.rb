class ProtectedApp
  def call(env)
    [200, {"Content-Type" => "text/html"}, "Hello World! From protected!\n"]
  end
end
