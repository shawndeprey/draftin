class Api::V1::CommentsController < Api::V1::BaseController
  before_filter :load_comment, :except => [:create]

  # POST /api/v1/comments.json
  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      render json: @comment, root: :comment, serializer: CommentSerializer
    else
      render json: @comment.errors.full_messages, status: :unprocessable_entity
    end
  end

  # PUT /api/v1/comments/:id.json
  def update
    if @comment.update_attributes(comment_params)
      render json: @comment, root: :comment, serializer: CommentSerializer
    else
      render json: @comment.errors.full_messages, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/comments/:id.json
  def destroy
    @comment.destroy
    head :no_content
  end

  private
  def load_comment
    @comment = Comment.find_by_id(params[:id]) || not_found
    return not_found unless @session_user.id == @comment.user.id
  end

  def comment_params
    params.require(:comment).permit(:content, :user_id, :chat_room_id, :article_id)
  end
end
