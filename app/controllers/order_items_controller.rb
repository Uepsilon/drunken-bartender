class OrderItemsController < ApplicationController

  def new
    @order_item = OrderItem.new
    @user = User.find(current_user.id)
    if not User.find(current_user.id).deliveries.empty?    
      @last_delivery = User.find(current_user.id).deliveries.order('created_at DESC').first.product.title
    end
    @bookings = @user.bookings.all
    @bookings_today = @user.bookings.where("created_at >= ?", Time.zone.now.beginning_of_day)
  end

  def create
    OrderItem.transaction do
      @order_item = OrderItem.new order_item_params
      @order = @order_item.build_order
      @order.build_booking user: current_user

      if @order_item.save
        redirect_to :new_order_item, notice: "Consumo sagt, #{@order_item.delivery.product.name} gebucht. Hai!"
      else
        redirect_to :new_order_item, alert: "Consumo sagt nix gut"
      end
    end
  end

  private

  def order_item_params
    params.require(:order_item).permit(:delivery_id, :amount)
  end
end
