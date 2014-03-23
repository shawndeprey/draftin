module ApplicationHelper
  def self.md5(string)
    return Digest::MD5.hexdigest("#{string}#{HASH_SALT}") if string
  end

  def markdown(text)
    options = [:hard_wrap, :filter_html, :autolink, :no_intraemphasis, :fenced_code, :gh_blockcode]
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    #Redcarpet.new(text, *options).to_html
    markdown.render(text).html_safe
  end
end
