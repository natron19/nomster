class PlacesController < ApplicationController

  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
    @places = Place.paginate(:page => params[:page], :per_page => 5)
  end

  def show
    @place = Place.find(params[:id])
    @comment = Comment.new
    @photo = Photo.new
  end

  def new
    @place = Place.new
  end

  def create
    @place = current_user.places.build(place_params)

    if @place.save
      redirect_to root_path, notice: "Place successfully added."
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
    @place = Place.find(params[:id])

    if @place.user != current_user
      return render text: 'Not Allowed', status: :forbidden
    end
  end

  def update
    @place = Place.find(params[:id])

    if @place.user != current_user
      return render text: 'Not Allowed', status: :forbidden
    end
    if @place.update_attributes(place_params)
      redirect_to root_path, notice: "Place successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @place = Place.find(params[:id])
    if @place.user != current_user
      return render text: 'Not Allowed', status: :forbidden
    end

    @place.destroy
    redirect_to root_path, notice: "Place was successfully deleted."
  end


  private

  def place_params
    params.require(:place).permit(:name, :description, :address)
  end

end
