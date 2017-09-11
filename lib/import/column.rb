class Import::Column
  def initialize(name, number, local_document)
    @name = name
    @number = number
    @local_document = local_document
  end

  def formatted_number
    number + 1
  end

  def preview_values
    Array.new(preview_count) do |i|
      column[i]
    end
  end

  def remaining_values_count
    column.compact.count - preview_values.compact.count
  end

  def rows
    @rows ||= begin
      CSV.foreach(local_document.path, csv_configuration)
    end
  end

  attr_reader :name, :number, :local_document

  private

  def preview_count
    2
  end

  def column
    rows.map { |row| row[number] }
  end

  def csv_configuration
    return { headers: true } if encoding_detector.blank?

    { headers: true, liberal_parsing: true,
      encoding: "#{encoding_detector[:encoding]}:UTF-8" }
  end

  def encoding_detector
    @encoding_detector ||= begin
      CharlockHolmes::EncodingDetector.detect(contents)
    end
  end

  def contents
    File.read(local_document.path)
  end
end
