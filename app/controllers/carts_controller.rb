class CartsController < ApplicationController
  def show
  end

  def destroy
    session[:cart_9527] = nil
    redirect_to root_path, notice: '購物車已清空'
  end
end
