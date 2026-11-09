# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[show edit update destroy]
  before_action :check_comment_owner, only: %i[edit update destroy]

  # GET /comments/1 or /comments/1.json
  def show; end

  # GET /comments/1/edit
  def edit; end

  # POST /comments or /comments.json
  def create
    commentable = if params[:book_id]
                    Book.find(params[:book_id])
                  else
                    Report.find(params[:report_id])
                  end
    @comment = commentable.comments.build(comment_params)
    @comment.user_id = current_user.id

    if @comment.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append(:comments, partial: 'comments/comment', locals: { comment: @comment }),
            turbo_stream.replace(:new_comment, partial: 'comments/create_form', locals: { comment: commentable.comments.build })
          ]
        end
        format.html { redirect_to commentable }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    if @comment.update(comment_params)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update(@comment, partial: 'comments/comment', locals: { comment: @comment })
        end
        format.html { redirect_to @comment.commentable }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    @comment.destroy!

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@comment) }
      format.html         { redirect_to @comment.commentable }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.includes(:commentable, :user).find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def comment_params
    params.expect(comment: :comment)
  end

  def check_comment_owner
    redirect_to @comment.commentable unless @comment.user_id == current_user.id
  end
end
