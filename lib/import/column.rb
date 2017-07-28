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
    @rows ||= CSV.foreach(document.path, headers: true)
  end

  attr_reader :name, :number, :document

  private

  def preview_count
    2
  end

  def column
    rows.map { |row| row[number] }
  end
end
