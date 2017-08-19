class ArticlesController < ApplicationController
  helper_method :article_image

  ARTICLES = [{
    id: 1,
    date: "2017-08-12",
    slug: "ya-puedes-recuperar-contraseña",
    title: "Ya puedes recuperar tu contraseñal"
  }, {
    id: 2,
    date: "2017-08-15",
    slug: "nuevo-layout-en-tu-lista-de-invitados",
    title: "Nuevo layout en tu lista de invitados"
  }]

  def show
    article = ARTICLES.detect{|a| a[:slug] == params[:id]}
    render file: "articles/#{article[:id]}", locals: {article: article}
  end

  private

  def article_image(article, path)
    view_context.image_tag "articles/#{article[:id]}/#{path}",
      class: "pitch__screenshot alert alert--default"
  end
end
