RestArea.class_whitelist = [Supermarket, Thing, Cereal]

RestArea.configure do
  resource :vegetable do
    key :name
    read_only!
    headers({
      'Cache-Control' => 'public, max-age=86400'
    })
  end

  resource :thing do
    messages :say_hello
  end
end
