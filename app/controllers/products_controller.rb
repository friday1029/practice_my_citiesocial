class ProductsController < ApplicationController
  before_action :validates_search_key, only: [:search]
  before_action :find_products_and_show_carousel, only: [:index, :search]
  def index
  end

  def show
    @product = Product.friendly.find(params[:id])
  end

  def search
    #@products = Product.ransack(description_cont: @q).result(distinct: true)
    @search_products = Product.on_sell_products.ransack(name_cont: @q).result(distinct: true)
  end
  private
  def validates_search_key
    @q = params[:query_string].gsub(/\\|\'|\/|\?/, "") if params[:query_string].present?
  end
  
  def find_products_and_show_carousel
    #@products = Product.where(on_sell: 'true').order(updated_at: :desc).includes(:vendor).with_attached_cover_image
    @products = Product.on_sell_products
    @show_products = @products.sample(6)
  end
end
