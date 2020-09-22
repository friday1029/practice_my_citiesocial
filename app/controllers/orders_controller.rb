class OrdersController < ApplicationController
  before_action :authenticate_user!
  def create
    @order = current_user.orders.build(order_params)
    current_cart.items.each do |item|
      @order.order_items.build(sku_id: item.sku_id, quantity: item.quantity)
    end
    if @order.save
      resp = Faraday.post("#{ENV['line_pay_endpoint']}/v2/payments/request") do |req|
        req.headers['Content-Type'] = 'application/json'
        req.headers['X-LINE-ChannelId'] = ENV['line_pay_channel_id']
        req.headers['X-LINE-ChannelSecret'] = ENV['line_pay_channel_secret']
        req.body = {
          productName: "練習五百倍大平台",
          amount: current_cart.total_price.to_i,
          currency: "TWD",
          confirmUrl: "http://localhost:4000/orders/confirm",
          orderId: @order.num
        }.to_json
      end
      result = JSON.parse(resp.body)
      if result["returnCode"] == "0000"
        payment_url = result["info"]["paymentUrl"]["web"]
        redirect_to payment_url
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
    resp = Faraday.post("#{ENV['line_pay_endpoint']}/v2/payments/#{params[:transactionId]}/confirm") do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['X-LINE-ChannelId'] = ENV['line_pay_channel_id']
      req.headers['X-LINE-ChannelSecret'] = ENV['line_pay_channel_secret']
      req.body = {
        amount: current_cart.total_price.to_i,
        currency: "TWD",
      }.to_json
    end
    result = JSON.parse(resp.body)
    if result["returnCode"] == "0000"
      order_id = result["info"]["orderId"]
      transaction_id = result["info"]["transactionId"]
      # 1. 變更 order 狀態
      order = current_user.orders.find_by(num: order_id)
      order.pay!(transaction_id: transaction_id)
      #在改變狀態時,可以一併送參數進去
      # 2. 清空購物車
      session[:cart_9527] = nil
      redirect_to root_path, notice: '付款已完成'
    else
      redirect_to root_path, notice: '付款發生錯誤'
    end
  end

  private

  def order_params
    params.require(:order).permit(:recipient, :tel, :address, :note)
  end
end
