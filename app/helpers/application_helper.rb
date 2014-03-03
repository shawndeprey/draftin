module ApplicationHelper
  def self.md5(string)
    return Digest::MD5.hexdigest("#{string}#{HASH_SALT}") if string
  end
end
