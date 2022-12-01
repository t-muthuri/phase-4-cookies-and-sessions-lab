class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  # GET request to /articles/:id
  def show
    # set session[:page_views] to an initial value of 0
    #  ||= used to assign a value if the current value is nil/false
    session[:page_views] ||= 0
    # increment by 1
    session[:page_views] += 1

    if session[:page_views] <= 3
    article = Article.find(params[:id])
    render json: article
    else
      render json: { error: "Maximum number of pages viewed reached"}, status: :unauthorized
    end
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end
