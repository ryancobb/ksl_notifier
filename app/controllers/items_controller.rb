class ItemsController < ApplicationController
  def index
    @items = ::Item.by_user(current_user)
  end

  def show
    @item = ::Item.by_user(current_user).find(params[:id])
    @listings = @item.listings.order('id ASC')
  end

  def new
    @item = ::Item.new
  end

  def create
    @item = ::Item.new(item_create_params)

    if @item.save
      flash[:success] = "Item successfuly created"
      redirect_to(@item)
    else
      flash[:error] = @item.errors.full_messages
      render :new
    end
  end

  def destroy
    @item = ::Item.by_user(current_user).find(params[:id])
    @item.destroy
 
    redirect_to items_path
  end

  def refresh
    @item = ::Item.by_user(current_user).find(params[:id])

    ::ScrapeItemWorker.perform_async(@item.id)
    flash[:notice] = "Updating item..."
    redirect_to @item
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
