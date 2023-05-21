class DocumentsController < ApplicationController


def new
  @document = Document.new
end

def create_new_file
  @document = Document.new(document_params)

  if @document.save
    redirect_to @document, notice: 'File uploaded successfully.'
  else
    render :new
  end
end

private

def document_params
  params.require(:document).permit(:file)
end
