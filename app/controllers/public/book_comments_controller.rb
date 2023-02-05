class Public::BookCommentsController < ApplicationController

    def create
        book = Book.find(params[:book_id])
        comment = current_customer.book_comments.new(book_comment_params)
        comment.book_id = book.id
        if comment.save
            flash[:notice] = "コメントの投稿に成功しました！"
            redirect_to request.referer
        else
            flash[:notice] = "不適切な内容なので投稿できません。お手数ですが最初からやり直してください。"
            redirect_to request.referer
        end
    end
    
    def destroy
        BookComment.find_by(id: params[:id], book_id: params[:book_id]).destroy
        redirect_to request.referer
    end
    
    private
    
    def book_comment_params
        params.require(:book_comment).permit(:comment)
    end
end
