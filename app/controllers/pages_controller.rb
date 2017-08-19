class PagesController < ApplicationController
  def index
    render locals: {articles: ArticlesController::ARTICLES}
  end
end
