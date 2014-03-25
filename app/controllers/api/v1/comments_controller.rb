class Api::V1::CommentsController < Api::V1::BaseController
  before_filter :load_comment, :except => [:index, :create]

  # GET /api/v1/comments.json
  def index
    return not_found unless params[:user_id] || params[:chat_room_id] || params[:article_id]
    if params[:chat_room_id]
      conditions = '"comments"."chat_room_id" = '+"#{params[:chat_room_id]}"
    elsif params[:user_id]
      conditions = '"comments"."user_id" = '+"#{params[:user_id]}"
    elsif params[:article_id]
      conditions = '"comments"."article_id" = '+"#{params[:article_id]}"
    end
    @comments = Comment.where(conditions || "id < 0")
                       .order('"comments"."created_at" DESC')
                       .paginate(page: params[:page], per_page: 20).reverse
    render json: @comments, root: :comments, each_serializer: CommentSerializer
  end

  # POST /api/v1/comments.json
  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      MetricsHelper::track(MetricsHelper::POST_COMMENT, {}, @session_user)
      render json: @comment, root: :comment, serializer: CommentSerializer
    else
      render json: @comment.errors.full_messages, status: :unprocessable_entity
    end
  end

  # PUT /api/v1/comments/:id.json
  def update
    if @comment.update_attributes(comment_params)
      MetricsHelper::track(MetricsHelper::UPDATE_COMMENT, {}, @session_user)
      render json: @comment, root: :comment, serializer: CommentSerializer
    else
      render json: @comment.errors.full_messages, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/comments/:id.json
  def destroy
    MetricsHelper::track(MetricsHelper::DELETE_COMMENT, {}, @session_user)
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
