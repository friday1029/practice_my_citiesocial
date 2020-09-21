class Api::V1::UtilsController < ApplicationController
  def subscribe
    email = params['subscribe']['email']
    sub  = Subscribe.new( email: email)
    if sub.save
      render json: { status: 'ok', email: email }
    else
      render json: { status: 'duplicated', email: email }
    end
  end

  def cart
    product = Product.friendly.find(params[:id])
    if product
      #current_cart.add_item(product.code, params[:quantity].to_i)
      #改成將 sku 加到 cart
      current_cart.add_sku( params[:sku], params[:quantity].to_i)
      session[:cart_9527] = current_cart.to_serialize
      render json: { status: 'ok', items: current_cart.items.count }
    end
  end
end
