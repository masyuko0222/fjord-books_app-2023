# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # ページを閲覧するには、ログインを必須に設定
  before_action :authenticate_user!
end
