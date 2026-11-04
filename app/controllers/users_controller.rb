# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @users = User.with_attached_icon
                 .order(:id)
                 .page(params[:page])
  end

  def show
    @user = User.with_attached_icon.find(params[:id])
  end
end
