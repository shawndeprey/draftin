# encoding: utf-8
class Article < ActiveRecord::Base
  nilify_blanks
  # attributes: title, content, created_at, updated_at
  has_many :comments
  default_scope includes(:comments)

  def self.latest_articles(page, per_page)
    Article.where('"articles"."id" >= 0').order('"articles"."updated_at" DESC').paginate(page: page, per_page: per_page)
  end
end