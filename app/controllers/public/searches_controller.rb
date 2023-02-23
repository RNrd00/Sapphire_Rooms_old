class Public::SearchesController < ApplicationController
  before_action :authenticate_customer!

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
end
