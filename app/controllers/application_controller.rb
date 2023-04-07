# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # ページを閲覧するには、ログインを必須に設定
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: %i[zipcode address profile])
  end
end
