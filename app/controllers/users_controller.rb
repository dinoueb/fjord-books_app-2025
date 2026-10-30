# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @users = User.includes(:icon_blob).page(params[:page])
  end

  def show
    @user = User.includes(:icon_blob).find(params[:id])
  end
end
