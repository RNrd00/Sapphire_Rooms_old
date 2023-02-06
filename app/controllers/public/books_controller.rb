class Public::BooksController < ApplicationController
    before_action :authenticate_customer!
    
    def index
        @book = Book.new
        @books = Book.all
        @customer = current_customer
    end

    def show
        @book = Book.find(params[:id])
        @customer = current_customer
        @book_comment = BookComment.new
    end
    
    def edit
    end
    
    def update
    end
    
    def create
        @book = Book.new(book_params)
            @book.customer_id = current_customer.id
        if  @book.save
            flash[:notice] = '投稿に成功しました！'
            redirect_to public_book_path(@book)
        else
            flash[:notice] = '操作が違うのでやり直してください'
            redirect_referer
        end
    end
    
  def destroy
    @book = Book.find(params[:id])
    if @book.delete_key == params[:key]
      @book.destroy
      flash[:notice] = '投稿を削除しました'
      redirect_to public_books_path
    else
      flash[:notice] = '削除パスワードが違います'
      redirect_referer
    end
  end
  
  private
  
  def book_params
    params.require(:book).permit(:name, :introduce, :delete_key)
  end
end
