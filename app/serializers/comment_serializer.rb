class CommentSerializer < ActiveModel::Serializer
  attributes :id, :username, :user_id, :content, :created_at

  def username
    object.user.username
  end

  def created_at
    object.created_at.strftime("%l:%M on %a").gsub(/^\s/,'')
  end

  def content
    ApplicationHelper.static_markdown(object.content)
  end
end