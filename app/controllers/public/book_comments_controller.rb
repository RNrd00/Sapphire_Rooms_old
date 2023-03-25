class Public::BookCommentsController < ApplicationController
  def create
    book = Book.find(params[:book_id])
    @comment = current_customer.book_comments.new(book_comment_params)
    @comment.book_id = book.id
    if @comment.save
    else
      render "error"
    end
  end

  def destroy
    @comment = BookComment.find(params[:id])
    @comment.destroy
  end

  private
    def book_comment_params
      params.require(:book_comment).permit(:comment)
    end
end
