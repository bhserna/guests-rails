class ArticlesController < ApplicationController
  helper_method :article_image, :article_video

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
  }, {
    id: 3,
    date: "2017-01-01",
    slug: "controles-más-simples-para-que-sea-más-fácil-crear-tu-lista-de-invitados",
    title: "Controles más simples para que sea más fácil crear tu lista de invitados"
  }, {
    id: 4,
    date: "2017-01-02",
    slug: "mantener-selección-del-grupo-al-agregar-o-realizar-acciones-en-tu-lista-de-invitados",
    title: "Mantener selección del grupo al agregar o realizar acciones en tu lista de invitados"
  }, {
    id: 5,
    date: "2017-01-12",
    slug: "busqueda-dentro-de-tu-lista-de-invitados",
    title: "Busqueda dentro de tu lista de invitados"
  }]

  def show
    article = ARTICLES.detect{|a| a[:slug] == params[:id]}
    render locals: {article: article}
  end

  private

  def article_image(article, path)
    view_context.image_tag "articles/#{article[:id]}/#{path}",
      class: "pitch__screenshot alert alert--default"
  end

  def article_video(article, path)
    view_context.video_tag "articles/#{article[:id]}/#{path}",
      class: "pitch__screenshot alert alert--default", controls: true
  end
end
