# encoding: utf-8
class Article < ActiveRecord::Base
  nilify_blanks
  # attributes: title, content, created_at, updated_at
end