module AreasHelper
  require 'roo'

  # Abre y lee un archivo xlsx para
  # generar un arreglo con los datos relacionados por jerarquia.
  #
  # @param file_path [String] - Ruta del archivo a leer como xlsx.
  # @return new_xlsx [Array] - Arreglo con los valores asociados.
  def process_file(file_path)
    xlsx = Roo::Spreadsheet.open file_path
    sheet = xlsx.sheet(0)
    associated_areas = []

    sheet.drop(1).each do |row|
      results = process_row(row)
      associated_areas << results
    end

    associated_areas.flatten
  end

  private

  # Lee la fila de la hoja de excel para generar un arreglo
  # con las areas padres e hijas asociadas.
  #
  # @param row [Array] - Fila con los valores de las celdas.
  # @return row_associations [Array] - Arreglo con los valores asociados.
  def process_row(row)
    @row_associations = []

    unless row.blank? or row.size == 0
      @current_association = {
        parent: nil,
        child: nil 
      }

      row.each_with_index do |cell, index|
        col_num = index + 1
        # Si hay area padre definida, define como area hija.
        unless @current_association[:parent].blank?
          @current_association[:child] = cell
          add_association @current_association
          # La última area no tiene area hija asociada.
          @current_association[:parent] = cell unless col_num == row.size
        else
          # Define primer valor como area como padre.
          @current_association[:parent] = cell
        end
      end
    end

    @row_associations
  end

  # Agrega una asociación al acomulador de resultados
  # de la fila procesada y reinicia el hash.
  #
  # @param hash [Hash]
  def add_association(hash)
    @row_associations << hash
    reset_current_association
  end

  # Resetea el hash que lleva la asociación entre
  # area padre e hija.
  def reset_current_association
    @current_association = {
      parent: nil,
      child: nil 
    }
  end
end
