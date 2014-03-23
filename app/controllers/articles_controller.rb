class ArticlesController < ApplicationController
  skip_before_filter :require_session, only: [:index, :show]
  before_action :permissions_check, except: [:index, :show]
  before_action :set_article, except: [:index, :new, :create]

  # GET /articles
  def index
    @articles = Article.latest_articles(params[:page], 9)
    if @session_user
      MetricsHelper::track(MetricsHelper::VIEW_ARTICLE_INDEX, {}, @session_user)
    end
  end

  # GET /articles/show
  def show
    if @session_user
      MetricsHelper::track(MetricsHelper::VIEW_ARTICLE, {title:@article.title}, @session_user)
    end
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  def create
    @article = Article.new(article_params)
    if @article.save
      redirect_to @article, notice: "Article successfully created!"
    else
      render action: "new"
    end
  end

  # PATCH/PUT /articles/1
  def update
    if @article.update(article_params)
      redirect_to @article, notice: "Article was successfully updated."
    else
      redirect_to edit_atricle_path(@article), alert: @article.errors.full_messages.join(" ")
    end
  end

  # DELETE /articles/1
  def destroy
    @article.destroy
    redirect_to articles_url, notice: "Article was successfully destroyed."
  end

  private
  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :content)
  end
end 