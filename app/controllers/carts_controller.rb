class CartsController < ApplicationController
  def show
  end

  def destroy
    session[:cart_9527] = nil
    redirect_to root_path, notice: '購物車已清空'
  end

  def checkout
    @order = current_user.orders.build  #以使用者的角度去新增一張訂單
  end

end
