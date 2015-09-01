# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Payments::Application.config.secret_key_base = 'e8bf87313c2dc77b63b88e7db2478720ca6e5a25f9e1881c8e0b2bd88c9452190f02ea371669109f3163c2205e2436db4a7bfaffd6927658ebf3c01999c9c5cb'
