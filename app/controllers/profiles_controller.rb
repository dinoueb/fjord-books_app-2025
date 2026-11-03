# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :set_user, only: %i[show edit update]
  before_action :check_owner_profile, only: %i[edit update]

  def show; end

  def edit; end

  def update
    is_email_changed = params[:user][:email] != @user.email
    is_password_changed = !params[:user][:password].empty? || !params[:user][:password_confirmation].empty?
    ActiveRecord::Base.transaction do
      @user.user_profile.update!(profile_params)

      raise ActiveRecord::RecordInvalid if (is_email_changed || is_password_changed) && !@user.update_with_password(user_params)
    end
  rescue ActiveRecord::RecordInvalid
    render :edit, status: :unprocessable_entity
  else
    bypass_sign_in(@user)
    redirect_to user_profile_path(@user), notice: t('controllers.common.notice_update', name: UserProfile.model_name.human)
  end

  private

  def set_user
    @user = User.includes(:user_profile).find(params[:user_id])
    @user.user_profile ||= @user.build_user_profile
  end

  def user_params
    params.expect(user: %i[email current_password password password_confirmation])
  end

  def profile_params
    params.expect(user: { user_profile: %i[zipcode address description] })[:user_profile]
  end

  def check_owner_profile
    redirect_to users_path, status: :forbidden unless @user.id == current_user.id
  end
end
