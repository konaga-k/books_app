# frozen_string_literal: true

module CommentsConcern
  private
    def set_commentable
      resource, id = request.path.split("/")[1, 2]
      @commentable = resource.singularize.classify.constantize.find(id)
    end

    def set_new_comment
      @comment = @commentable.comments.build(comment_params)
    end

    def set_comment
      @comment = @commentable.comments.find_by(id: params[:id], user: current_user)
    end

    def comment_params
      params.require(:comment).permit(:body)
    end
end
