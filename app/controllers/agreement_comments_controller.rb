class AgreementCommentsController < ApplicationController
  def create
    @agreement_comment = AgreementComment.new(params.require(:agreement_comment).permit(:content, :individual_id, :agreement_id))
    if @agreement_comment.save
      flash[:notice] = "Comment created"
      redirect_to agreement_path(@agreement_comment.agreement)
    end      
  end
end