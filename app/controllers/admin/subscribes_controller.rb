class Admin::SubscribesController < Admin::BaseController
  before_action :find_subscribe, only: [:destroy]
  def index
    @subscribes = Subscribe.order( created_at: :desc)
    #@products = Product.includes(:vendor).with_attached_cover_image
  end

  def destroy
    @subscribe.destroy
    redirect_to admin_subscribes_path, notice: '訂閱Email已刪除'
  end


  def find_subscribe
    @subscribe = Subscribe.find(params[:id])
  end
end
