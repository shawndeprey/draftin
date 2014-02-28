module ApplicationHelper
  # Bootstrap Guide Resource: http://railsapps.github.io/twitter-bootstrap-rails.html

  # Simple Form for Twitter Bootstrap
  # Inside your views, use the 'simple_form_for' with one of the Bootstrap form
  # classes, '.form-horizontal', '.form-inline', '.form-search' or
  # '.form-vertical', as the following:
  #
  #   = simple_form_for(@user, html: {class: 'form-horizontal' }) do |form|
  
  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end
end
