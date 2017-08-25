class Import::Column
  def initialize(name, number, document)
    @name = name
    @number = number
    @document = document
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
      CSV.foreach(document.path, headers: true, encoding: "#{encoding}:UTF-8")
    end
  end

  attr_reader :name, :number, :document

  private

  def preview_count
    2
  end

  def column
    rows.map { |row| row[number] }
  end

  def encoding
    encoding_detector && encoding_detector[:encoding]
  end

  def encoding_detector
    @encoding_detector ||= begin
      CharlockHolmes::EncodingDetector.detect(contents)
    end
  end

  def contents
    File.read(document.path)
  end
end
