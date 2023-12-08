class Table

  attr_accessor :ws, :headers

  include Enumerable

  def initialize(ws)
    @ws = ws
    @selected = []
    @selectedHeader = 0
    @headers = []
    add_method
    deleteEmptyRows
    ignoreTotalSubtotal
  end

  def getTableMatrix()
    matrix = (1..@ws.num_rows).map { |row| (1..@ws.num_cols).map { |col| @ws[row, col] } } #TODO: nista
  end

  def row(index)
    array = (1..@ws.num_cols).map { |col| @ws[index, col] } #TODO: nista
  end

  def each
    getTableMatrix.each { |row| row.each { |col| yield col } } #TODO: nista
  end

  def sum
    @selected.map(&:to_f).sum
  end

  def avg
    @selected.map(&:to_f).sum/@selected.length
  end

  def map
    results = []
    @selected.each do |element|
      results << yield(element)
    end
    results
  end

  def select
    result = []
    @selected.each do |element|
      result << element if yield(element)
    end
    result
  end

  def reduce(init_val = nil)
    accumulator = init_val.nil? ? @selected[0].to_f : init_val
    @selected.each do |element|
      accumulator = yield(accumulator, element.to_f)
    end
    accumulator
  end

  def deleteEmptyRows()
    # matrix = getTableMatrix.reject.each_with_index { |row, index| row.all? { |element| element.nil? || element.to_s.strip.empty? } }
    empty_rows = (getTableMatrix.each_with_index.select { |row, index| row.all? { |element| element.nil? || element.to_s.strip.empty? } }).map{|pair| pair.last}
    delete = 0
    empty_rows.each do |index|
      @ws.delete_rows(index+1-delete, 1)
      delete += 1
    end
    getTableMatrix
  end

  def ignoreTotalSubtotal()
    indexRows = []
    (1..@ws.num_rows).each do |row|
      (1..@ws.num_cols).each do |col|
        indexRows.append(row) if @ws[row, col].eql?("Total") || @ws[row, col].eql?("Subtotal")
      end
    end
    delete = 0
    indexRows.each do |index|
      @ws.delete_rows(index-delete, 1)
      delete += 1
    end
    getTableMatrix
  end

  def add_method
    @headers = (1..@ws.num_cols).map { |cols| @ws[1, cols].gsub(' ', '_')}
    @headers.each_with_index do |header, index|
      define_singleton_method("#{header}") do
        result = (0...@ws.num_rows-1).map { |cols| @ws.list[cols][header.gsub('_',' ')]}
        @selected = result
        @selectedHeader = index
        self
      end
    end
  end

  def method_missing(key, *args)
    name = key.to_s
    val = @selected.index name
    result = val.nil? ? nil : (1..@ws.num_cols).map { |cols| @ws[val + 2, cols] }
  end

  def +(obj)
    obj.instance_of?(Table) && obj.headers.eql?(@headers) && (2..@ws.num_rows).each { |row| (1..@ws.num_cols).each { |col| @ws[row, col] += obj.ws[row, col] } }
    getTableMatrix
  end

  def -(obj)
    obj.instance_of?(Table) && obj.headers.eql?(@headers) && (2..@ws.num_rows).each { |row| (1..@ws.num_cols).each { |col| (@ws[row, col].clear) if @ws[row, col].eql? obj.ws[row, col] } }
    getTableMatrix
  end

  def [](index)
    begin
      array = (0...@ws.num_rows-1).map { |i| @ws.list[i][index] }
      Column.new(array, index, self)
    rescue => error
      p "There is no column named #{index}"
      nil
    end
  end

  def []=(row, column, value)
    @ws.list[column][row].nil? ? nil : @ws.list[column][row] = value
  end

  def inspect
    @selected
  end

end

class Column

  def initialize(values, key, table)
    @values, @key, @table = values, key, table
  end

  def [](index) #TODO: nill
    @values[index]
  end

  def []=(index, value)
    @table.[]=(@key, index, value)
  end

  def inspect
    @values
  end

end
