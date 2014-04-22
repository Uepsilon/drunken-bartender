class DeliveriesController < ApplicationController

  def index
    @filters = Delivery.order('created_at DESC').search(params[:q])
    @deliveries = @filters.result(distinct: true).paginate(page: params[:page])
    @deliveries = @deliveries.send(created_at_eq) unless created_at_eq.blank?
  end

  def new
    @delivery = Delivery.new
  end

  def create
    @delivery = Delivery.new delivery_params
    @delivery.user = current_user

    if @delivery.save
      redirect_to :deliveries, notice: "Lieferung angelegt."
    else
      render :new
    end
  end

  def destroy
    begin
      @delivery = current_user.deliveries.find params[:id]
      @delivery.destroy

      redirect_to :deliveries, notice: "Lieferung gelöscht."
    rescue ActiveRecord::RecordNotFound
      redirect_to :deliveries, alert: "Spiel mit deinen eigenen Sachen!"
    end
  end

  def search
    index
    render :index
  end

  private

  def delivery_params
    params.require(:delivery).permit(:product_id, :quantity, :price)
  end
end
