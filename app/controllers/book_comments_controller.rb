class BookCommentsController < ApplicationController
  before_action :authenticate_user!


  def create
    @book = Book.find(params[:book_id])
    @book_comment = BookComment.new(book_comment_params)
    @book_comment.book_id = @book.id
    @book_comment.user_id = current_user.id
    unless @book_comment.save
      render 'error'
    end
  end

    #１行目：book = Book.find(params[:book_id])
    #(params[:book_id])　で、本の投稿から”ある投稿”を取り出せます。
    #findメソッドを利用して、データベース　から取り出して、bookというローカル変数に入れてあります。
    #２行目　：コメントを新規投稿するための空のインスタンスを作っています。
    #３行目：comment.book_id=book.id
    #空のインスタンスのbook_idは、今取り出してる"ある投稿”のidだよという意味だと思います。
    #”ある投稿”に対してコメントしますよ〜という感じ

  def destroy
    @book=Book.find(params[:book_id])
    book_comment=@book.book_comments.find(params[:id])
    book_comment.destroy
  end


  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end

end