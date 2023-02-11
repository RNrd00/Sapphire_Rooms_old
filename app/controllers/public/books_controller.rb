class Public::BooksController < ApplicationController
    before_action :move_to_sign_in, expect: [:index, :show, :edit, :update, :create, :destroy]
    
    def index
        to = Time.current.at_end_of_day
        from = (to - 6.day).at_beginning_of_day
        @books = Book.all.sort {|a,b|
            b.favorites.where(created_at: from...to).size <=>
            a.favorites.where(created_at: from...to).size
        }
        @book = Book.new
        @customer = current_customer
    end

    def show
        @book = Book.find(params[:id])
        unless ViewCount.find_by(customer_id: current_customer.id, book_id: @book.id)
            current_customer.view_counts.create(book_id: @book.id)
        end
        @book_comment = BookComment.new
        @customer = current_customer
    end
    
    def edit
        @book = Book.find(params[:id])
    end
    
    def create
        @book = Book.new(book_params)
            @book.customer_id = current_customer.id
        if  @book.save
            redirect_to public_book_path(@book), notice: '投稿に成功しました！'
        else
            @books = Book.all
            @customer = current_customer
            render 'index'
        end
    end
    
  def destroy
    @book = Book.find(params[:id])
    if @book.delete_key == params[:key]
      @book.destroy
      redirect_to public_books_path, notice: '投稿を削除しました'
    else
      flash[:notice] = '削除パスワードが違います'
      @customer = current_customer
      @book = Book.find(params[:id])
      @book_comment = BookComment.new
      render 'show'
    end
  end
  
    def update
        @book = Book.find(params[:id])
        if @book.update(book_params)
            redirect_to public_book_path(@book), notice: '編集に成功しました！'
        else
            render 'edit'
        end
    end
  
  private
  
  def book_params
    params.require(:book).permit(:name, :introduce, :delete_key)
  end
  
  def move_to_sign_in
      unless customer_signed_in? || admin_signed_in?
          redirect_to new_customer_session_path
      end
  end
end
