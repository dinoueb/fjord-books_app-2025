# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :set_user, only: %i[show edit update]
  def show; end

  def edit; end

  def update
    has_password_param = !params[:user][:current_password].empty? || !params[:user][:password].empty? || !params[:user][:password_confirmation].empty?
    ActiveRecord::Base.transaction do
      is_commit = if has_password_param
                    @user.update_with_password(user_params)
                  else
                    @user.update_without_password(user_params.slice(:email))
                  end

      @user.user_profile.update!(profile_params)

      raise ActiveRecord::RecordInvalid unless is_commit
    end
  rescue ActiveRecord::RecordInvalid
    render :edit, status: :unprocessable_entity
  else
    bypass_sign_in(@user)
    redirect_to profile_path, notice: t('controllers.common.notice_update', name: UserProfile.model_name.human)
  end

  private

  def set_user
    @user = User.includes(:user_profile).find(current_user.id)
    @user.user_profile ||= @user.build_user_profile
  end

  def user_params
    params.expect(user: %i[email current_password password password_confirmation])
  end

  def profile_params
    params.expect(user: { user_profile: %i[zipcode address description] })[:user_profile]
  end
end
