class AttachmentsController < ApplicationController
  skip_after_action :verify_authorized, only: [:new]

  def show
    attachment = Attachment.find(params[:id])
    authorize attachment, :show?
    send_file attachment.file.path, disposition: :inline
  end
end
