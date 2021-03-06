class BooksController < ApplicationController
  def show
    @new_book = Book.new
    @book = Book.find(params[:id])
    @user = @book.user
    @book_comment = BookComment.new
  end

  def index
    @user = current_user
    @books = Book.all
    @new_book = Book.new
    @q = Book.ransack(params[:q])
    @books_count = @q.result(distinct: true).includes(:user)
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      redirect_to books_path
      flash[:alert] = "can't be blank"
    end
  end

  def edit
    @book = Book.find(params[:id])
    redirect_to books_path if @book.user_id != current_user.id
  end


  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :created_at)
  end
end
