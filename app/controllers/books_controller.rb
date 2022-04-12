class BooksController < ApplicationController

  def show #book_path
    @newbook = Book.new
    @book = Book.find(params[:id])
    unless AddImpressionsCountToBook.find_by(user_id: current_user.id, book_id: @book.id)
      current_user.add_impressions_count_to_books.create(book_id: @book.id)
    end
    @users=@book.user
    @book_comment = BookComment.new
    @tweet = Book.find(params[:id])
    impressionist(@tweet, nil, unique: [:session_hash])
  end

  def index #books_path
    to  = Time.current.at_end_of_day
    from  = (to - 6.day).at_beginning_of_day
    @books = Book.includes(:favorited_users).#includes 1回で本の投稿とそれに紐づいているユーザーの情報が取り出せるようになります。
      sort {|a,b|
        b.favorited_users.includes(:favorites).where(created_at: from...to).size <=>
        a.favorited_users.includes(:favorites).where(created_at: from...to).size
      }
    @book = Book.new
    @user=current_user
  end

  def create
    @book = Book.new(book_params)
    @book.user_id=current_user.id
    if @book.save
      redirect_to book_path(@book.id), notice: "You have created book successfully."
    else
    @books = Book.all
    @user=current_user
    render:index
    end
  end

  def edit
    @book = Book.find(params[:id])
    unless @book.user==current_user
    redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
    render:edit
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title,:body)
  end
end