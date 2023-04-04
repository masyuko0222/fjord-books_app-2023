# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # ActiveStorageとUserモデルの紐づけ
  has_one_attached :icon
end
