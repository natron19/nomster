class PlacesController < ApplicationController

  before_action :authenticate_user!, only: [:new, :create]

  def index
    @places = Place.paginate(:page => params[:page], :per_page => 5)
  end

  def show
    @place = Place.find(params[:id])
  end

  def new
    @place = Place.new
  end

  def create
    @place = current_user.places.create(place_params)

    if @place.save
      redirect_to root_path, notice: "Place successfully added."
    else
      render 'new'
    end
  end

  def edit
    @place = Place.find(params[:id])
  end

  def update
    @place = Place.find(params[:id])

    if @place.update_attributes(place_params)
      redirect_to root_path, notice: "Place successfully updated."
    else
      render 'edit'
    end
  end

  def destroy
    @place = Place.find(params[:id])

    if @place.destroy
      redirect_to root_path, notice: "Place was successfully deleted."
    else
      render 'new'
    end
  end


  private

  def place_params
    params.require(:place).permit(:name, :description, :address)
  end

end
