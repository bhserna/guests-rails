class PagesController < ApplicationController
  def index
    render locals: {articles: ArticlesController::ARTICLES.reverse}
  end
end
