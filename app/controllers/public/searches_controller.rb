class Public::SearchesController < ApplicationController
  before_action :move_to_sign_in, expect: %i[search]

  def search
    @model = params[:model]
    @content = params[:content]
    @method = params[:method]
    if @model == "customer"
      @records = Customer.search_for(@content, @method).page(params[:page])
    elsif @model == "book"
      @records = Book.search_for(@content, @method).page(params[:page])
    elsif @model == "tag"
      @records = Tag.search_ratings_for(@content, @method)
      @records = Kaminari.paginate_array(@records).page(params[:page])
    elsif @model == "book_tag"
      @records = Tag.search_books_for(@content, @method)
      @records = Kaminari.paginate_array(@records).page(params[:page])
    end
  end

  def move_to_sign_in
    return if customer_signed_in? || admin_signed_in?

    redirect_to new_customer_session_path, notice: "ログインしてください。"
  end
end
