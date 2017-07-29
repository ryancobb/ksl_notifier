class ItemsController < ApplicationController
  def index
    @items = Item.by_user(current_user)
  end

  def show
    @item = Item.by_user(current_user).find(params[:id])
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_create_params)

    if @item.save
      flash[:success] = "Item successfuly created"
      redirect_to(@item)
    else
      flash[:error] = @item.errors.full_messages
      render :new
    end
  end

  private

  def item_create_params
    params.require(:item).permit(:name, :search_url).merge(
      :user_id => current_user.id
    )
  end

  def item_find_params
  end

end
