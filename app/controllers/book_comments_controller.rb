class BookCommentsController < ApplicationController
  def create
    book = Book.find(params[:book_id])
    comment = current_user.book_comments.new(book_comment_params)
    comment.book_id = book.id
    comment.save
    redirect_back(fallback_location: root_path)
  end
    #１行目：book = Book.find(params[:book_id])　
    #(params[:book_id])　で、本の投稿から”ある投稿”を取り出せます。
    #findメソッドを利用して、データベース　から取り出して、bookというローカル変数に入れてあります。
    #２行目　：コメントを新規投稿するための空のインスタンスを作っています。
    #３行目：comment.book_id=book.id　　
    #空のインスタンスのbook_idは、今取り出してる"ある投稿”のidだよという意味だと思います。
    #”ある投稿”に対してコメントしますよ〜という感じ

  def destroy
    BookComment.find(params[:id]).destroy
     redirect_back(fallback_location: root_path)
  end



  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end
end