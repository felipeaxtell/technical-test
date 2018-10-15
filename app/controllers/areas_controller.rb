class AreasController < ApplicationController
  protect_from_forgery with: :exception
  include AreasHelper

  def index
  end

  def generate_xlsx
    file = generate_xlsx_params[:file]
    @associated_areas = process_file(file.path)

    render xlsx: 'generate_xlsx', template: 'areas/generate_xlsx.xlsx.axlsx', filename: 'areas.xlsx', disposition: 'download'
  end

  def generate_xlsx_params
    params.require(:areas).permit(:file)
  end
end