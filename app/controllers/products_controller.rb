class ProductsController < ApplicationController
  before_action :validates_search_key, only: [:search]
  def index
    @products = Product.order(updated_at: :desc).includes(:vendor)
    @show_products = @products.sample(6)
  end

  def show
    @product = Product.friendly.find(params[:id])
  end

  def search
    #@products = Product.ransack(description_cont: @q).result(distinct: true)
    @products = Product.ransack(name_cont: @q).result(distinct: true)
  end
  private
  def validates_search_key
    @q = params[:query_string].gsub(/\\|\'|\/|\?/, "") if params[:query_string].present?
  end
end
