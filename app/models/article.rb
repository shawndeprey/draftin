# encoding: utf-8
class Article < ActiveRecord::Base
  nilify_blanks
  # attributes: title, content, created_at, updated_at

  def self.latest_articles(page, per_page)
    Article.where('id >= 0').order('updated_at DESC').paginate(page: page, per_page: per_page)
  end
end