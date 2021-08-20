class Api::V1::HomepageController < Api::V1::AuthorizationController
  def index
    data = Homepage.new(current_user)
    render json: HomepageSerializer.new(data)
  end
end
