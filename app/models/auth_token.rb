class AuthToken < ActiveRecord::Base
  
  APP_SECRET          = "NKSLG53TM37LI48FDDP2LV278P"
  DEFAULT_EXPIRY_TIME = 1.days.to_i * 1000

  # TOKEN = Base64.encode(user_id::expires::hash)
  # HASH  = Digest::SHA256.new.digest(user_id::expires::APP_SECRET)
  def self.create_token(user_id)
    expires = (Time.now.to_f * 1000).to_i + DEFAULT_EXPIRY_TIME
    token   = "#{user_id}::#{expires}"
    hash    = Digest::SHA256.new.digest("#{token}::#{APP_SECRET}")
    { :token => Base64.strict_encode64("#{token}::#{hash}"), :expires => expires }
  end

  def self.find_user(token)
    parts = Base64.strict_decode64(token).split("::")
    unless parts.length == 3
      raise TokenException.new("Bad Token - Invalid Parts")
    end
    if parts[1].to_i == 0
      raise TokenException.new("Bad Token - Invalid Expiry")
    end
    expires = parts[1].to_i
    unless expires > (Time.now.to_f * 1000).to_i
      raise TokenException.new("Token has expired")
    end
    hash = parts[2]
    unless Digest::SHA256.new.digest("#{parts[0]}::#{parts[1]}::#{APP_SECRET}") == hash
      raise TokenException.new("Bad Token - Hash Mismatch")
    end
    User.find(parts[0].to_i)
  end

  class TokenException < Exception
  end
end
