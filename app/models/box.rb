class Box
  attr_accessor :row, :column, :square, :value, :possibilities, :row_checked, :square_checked, :column_checked

  def initialize(x, y, z, val)
    @row = x
    @column = y
    @square = z
    @possibilities = [1,2,3,4,5,6,7,8,9]
    @value = val
    @row_checked = false
    @square_checked = false
    @column_checked = false

    if val > 0
      @possibilities = []
    end
  end

  def has_value
    @value > 0
  end

  def remove_possibility(val)
    possibilities.delete(val)
    if possibilities.length === 1
      set_value(possibilities[0])
    end
  end

  def set_value(val)
    @value = val
    @possibilities = []
  end

  def print_val
    print @value.to_s + ' '
    if @column === 9
      puts
    end
  end

  def equals(box)
    @row === box.row && @column === box.column && @square === box.square
  end
end