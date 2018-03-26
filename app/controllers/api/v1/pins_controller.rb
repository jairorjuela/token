class Api::V1::PinsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate


  def index
    render json: Pin.all.order('created_at DESC')
  end

  def create
    pin = Pin.new(pin_params)
    if pin.save
      render json: pin, status: 201
    else
      render json: { errors: pin.errors }, status: 422
    end
  end

  private

  def authenticate
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    user = User.find_by(email:request.headers["X-User-Email"])
    token = request.headers["X-Api-Token"]
    if (user && token == user.api_token)
        true
      else
        false
    end
  end

  def render_unauthorized
    self.headers["X-Api-Token"] = 'Token realm="Application"'
    render json: 'Bad credentials', status: 401
  end



    def pin_params
      params.require(:pin).permit(:title, :image_url)
    end
end
