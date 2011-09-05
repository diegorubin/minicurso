#encoding: utf-8
class SnippetsController < ApplicationController

  before_filter :get_snippet, :only => [:edit, :update, :destroy, :show]

  def index
    @snippets = Snippet.all
  end

  def new
    @snippet = Snippet.new
  end

  def create
    @snippet = Snippet.new(params[:snippet])

    if @snippet.save
      flash[:notice] = "Salvo com sucesso."
      redirect_to :action => :index
    else
      flash[:alert] = "Não salvou"
      render :action => :new
    end
  end

  def edit
  end

  def update
    if @snippet.update_attributes(params[:snippet])
      flash[:notice] = "Atualizado"
      redirect_to :action => :index
    else
      flash[:alert] = "nao atualizou"
      render :action => :edit
    end
  end

  def destroy
    if @snippet.destroy
      flash[:notice] = "removido."
      redirect_to :action => :index
    end
  end

  def show

  end

  protected
  def get_snippet
    @snippet = Snippet.find(params[:id])
  end

end
