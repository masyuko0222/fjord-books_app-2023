# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # ログイン済ユーザーのみアクセスを許可
  before_action :authenticate_user!

  # deviseコントローラにストロングパラメータを追加
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[post_code address introduction])

    devise_parameter_sanitizer.permit(:account_update, keys: %i[post_code address introduction])
  end
end
