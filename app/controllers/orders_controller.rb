class OrdersController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @orders = current_user.orders.order(id: :desc)
  end

  def create
    @order = current_user.orders.build(order_params)
    current_cart.items.each do |item|
      @order.order_items.build(sku_id: item.sku_id, quantity: item.quantity)
    end
    if @order.save
      linepay = LinepayService.new("/payments/request")
      linepay.perform(
        {
          productName: "David CitieSocial練習",
          amount: current_cart.total_price.to_i,
          currency: "TWD",
          confirmUrl: "http://localhost:4000/orders/confirm",
          productImageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/62/Ruby_On_Rails_Logo.svg/300px-Ruby_On_Rails_Logo.svg.png",
          orderId: @order.num
        }
      )
      if linepay.success?
        redirect_to linepay.payment_url
      else
        flash[:notice] = "付款發生錯誤"
        render 'carts/checkout'
      end
    else
      flash[:notice] = "付款發生錯誤"
      render 'carts/checkout'
    end
  end

  def confirm
    linepay = LinepayService.new("/payments/#{params[:transactionId]}/confirm")
    linepay.perform(
      {
        amount: current_cart.total_price.to_i,
        currency: "TWD",
      }
    )   
    if linepay.success?
      # 1. 變更 order 狀態
      order = current_user.orders.find_by(num: linepay.order_id)
      order.pay!(transaction_id: linepay.transaction_id)
      #在改變狀態時,可以一併送參數進去
      # 2. 清空購物車
      session[:cart_9527] = nil
      redirect_to root_path, notice: '付款已完成'
    else
      redirect_to root_path, notice: '付款發生錯誤'
    end
  end

  def pay
    @order = current_user.orders.find(params[:id])
    linepay = LinepayService.new("/payments/request")
    linepay.perform(
      {
        productName: "David CitieSocial練習",
        amount: @order.total_price.to_i,
        currency: "TWD",
        confirmUrl: "http://localhost:4000/orders/#{@order.id}/pay_confirm",
        productImageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/62/Ruby_On_Rails_Logo.svg/300px-Ruby_On_Rails_Logo.svg.png",
        orderId: @order.num
      }
    )
    if linepay.success?
      redirect_to linepay.payment_url
    else
      redirect_to orders_path, notice: '付款發生錯誤'
    end
  end
  
  def pay_confirm
    @order = current_user.orders.find(params[:id])
    linepay = LinepayService.new("/payments/#{params[:transactionId]}/confirm")
    linepay.perform(
      {
        amount: @order.total_price.to_i,
        currency: "TWD",
      }
    )
    if  linepay.success?
      # 1. 變更 order 狀態
      @order = current_user.orders.find_by(num: linepay.order_id)
      @order.pay!(transaction_id: linepay.transaction_id)
      #在改變狀態時,可以一併送參數進去
      redirect_to root_path, notice: '付款已完成'
    else
      redirect_to root_path, notice: '付款發生錯誤'
    end
  end

  def cancel
    @order = current_user.orders.find(params[:id])
    if @order.paid?
      linepay = LinepayService.new("/payments/#{@order.transaction_id}/refund")
      linepay.perform
      if linepay.success?
        @order.cancel!
        redirect_to orders_path, notice: "訂單#{@order.num}已取消,並完成退款"
      else
        redirect_to orders_path, notice: "訂單#{@order.num}取消發生錯誤"
      end
    else
      @order.cancel!
      redirect_to orders_path, notice: "訂單#{@order.num}已取消"
    end
  end

  private

  def order_params
    params.require(:order).permit(:recipient, :tel, :address, :note)
  end
end
