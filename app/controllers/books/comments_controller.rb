# frozen_string_literal: true

class Books::CommentsController < ApplicationController
  before_action :set_book
  before_action :set_comment, only: [:edit, :update, :destroy]

  def edit
  end

  def create
    @comment = @book.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @book, notice: t("view.book/comment.notice.create")
    else
      @comments = @book.comments
                       .includes(user: { avatar_attachment: :blob })
                       .order(created_at: :asc)
                       .page(params[:page])
                       .per(10)
      render "books/show"
    end
  end

  def update
    if @comment.update(comment_params)
      redirect_to @book, notice: t("view.book/comment.notice.update")
    else
      render :edit
    end
  end

  def destroy
    @comment.destroy
    redirect_to @book, notice: t("view.book/comment.notice.destroy")
  end

  private
    def set_book
      @book = Book.find(params[:book_id])
    end

    def set_comment
      @comment = @book.comments.find_by(id: params[:id], user: current_user)
    end

    def comment_params
      params.require(:book_comment).permit(:body)
    end
end
