class OrdersController < ApplicationController
  def create
    @order = current_user.orders.bulid(order_params)
    current_cart.items.each do |item|
      @order.order_items.build(sku_id: 0, quantity: item.quantity)
    end
    if @order.save
      redirect_to root_path, notice: 'ok!'
    else
      render 'cart/checkout'
    end
  end
  private
  def order_params
    params.require(:order).permit[:recipient, :tel, :address, :note]
  end
end
