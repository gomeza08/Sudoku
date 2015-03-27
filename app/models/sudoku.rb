class Sudoku
  attr_accessor :boxes, :unsolved_rows, :unsolved_columns, :unsolved_squares, :possible_solutions

  def initialize(vals)
    raise ArgumentError.new('Sudokus have 27 boxes') unless vals.length != 27
    boxes = []
    rows = 1
    while rows < 10
      cols = 1
      while cols < 10
        if rows < 4 && cols < 4
          boxes.push(Box.new(rows, cols, 1, vals.shift))
        elsif rows < 7 && cols < 4
          boxes.push(Box.new(rows, cols, 2, vals.shift))
        elsif rows < 10 && cols < 4
          boxes.push(Box.new(rows, cols, 3, vals.shift))
        elsif rows < 4 && cols < 7
          boxes.push(Box.new(rows, cols, 4, vals.shift))
        elsif rows < 7 && cols < 7
          boxes.push(Box.new(rows, cols, 5, vals.shift))
        elsif rows < 10 && cols < 7
          boxes.push(Box.new(rows, cols, 6, vals.shift))
        elsif rows < 4 && cols < 10
          boxes.push(Box.new(rows, cols, 7, vals.shift))
        elsif rows < 7 && cols < 10
          boxes.push(Box.new(rows, cols, 8, vals.shift))
        elsif rows < 10 && cols < 10
          boxes.push(Box.new(rows, cols, 9, vals.shift))
        end
        cols = cols+1
      end
      rows = rows+1
    end

    @unsolved_rows = []
    @unsolved_columns = []
    @unsolved_squares = []
    @possible_solutions = []
    @boxes = boxes

    checks = 1
    while checks < 10
      unless get_row(checks).all? {|box| box.has_value}
        @unsolved_rows.push(checks)
      end
      unless get_column(checks).all? {|box| box.has_value}
        @unsolved_columns.push(checks)
      end
      unless get_square(checks).all? {|box| box.has_value}
        @unsolved_squares.push(checks)
      end
      checks = checks+1
    end
  end

  def get_row(row)
    @boxes.select {|box| box.row === row}
  end

  def get_column(col)
    @boxes.select {|box| box.column === col}
  end

  def get_square(square)
    boxes.select {|box| box.square === square}
  end

  def unsolved
    @unsolved_squares.length+@unsolved_columns.length+unsolved_rows.length > 0
  end

  def solve
    while unsolved
      unless is_valid_sudoku
        if @possible_solutions.size === 0
          break
        end
        current = @possible_solutions.pop
        @boxes = current[:boxes]
        @unsolved_rows = current[:unsolved_rows]
        @unsolved_columns = current[:unsolved_columns]
        @unsolved_squares = current[:unsolved_squares]
      end
      changes = check_rows+check_columns+check_squares
      if changes === 0
        key_box = @boxes.find{|box| box.possibilities.length === 2}
        key_box.possibilities.each {|possibility|
          clone = YAML::load(@boxes.to_yaml)
          clone_box = clone.find {|box| box.equals(key_box)}
          clone_box.set_value(possibility)
          @possible_solutions.push({:boxes => clone,
                                     :unsolved_rows => YAML::load(@unsolved_rows.to_yaml),
                                     :unsolved_columns => YAML::load(@unsolved_columns.to_yaml),
                                     :unsolved_squares => YAML::load(@unsolved_squares.to_yaml)})
        }
        @boxes = @possible_solutions.pop[:boxes]
      end
    end
  end

  def check_rows
    rows_changes = 0
    @unsolved_rows.each {|row| rows_changes += check_row(row)}
    rows_changes
  end

  def check_columns
    columns_changes = 0
    @unsolved_columns.each {|row| columns_changes += check_column(row)}
    columns_changes
  end

  def check_squares
    squares_changes = 0
    @unsolved_squares.each {|row| squares_changes += check_square(row)}
    squares_changes
  end

  def check_row(row)
    changes = 0
    total_possibilities = []
    get_row(row).each{|box1|
      unless box1.row_checked || !box1.has_value
        box1.row_checked = true
        get_row(row).each{|box2| box2.remove_possibility(box1.value)}
        changes += 1
      end
      total_possibilities += box1.possibilities
    }
    if get_row(row).all? {|box| box.has_value}
      @unsolved_rows.delete(row)
    end
    get_row(row).each{|box|
      unless box.has_value
        get_unique_possibilities(total_possibilities).each{|num|
          if box.possibilities.include?(num)
            box.set_value(num)
            changes += 1
          end
        }
      end
    }
    changes
  end

  def check_column(col)
    changes = 0
    total_possibilities = []
    get_column(col).each{|box1|
      unless box1.column_checked || !box1.has_value
        box1.column_checked = true
        get_column(col).each{ |box2| box2.remove_possibility(box1.value)}
        changes += 1
      end
      total_possibilities += box1.possibilities
    }
    if get_column(col).all? {|box| box.has_value}
      @unsolved_columns.delete(col)
    end
    get_column(col).each{|box|
      unless box.has_value
        get_unique_possibilities(total_possibilities).each{|num|
          if box.possibilities.include?(num)
            box.set_value(num)
            changes += 1
          end
        }
      end
    }
    changes
  end

  def check_square(square)
    changes = 0
    total_possibilities = []
    get_square(square).each{|box1|
      unless box1.square_checked || !box1.has_value
        box1.square_checked = true
        get_square(square).each{ |box2| box2.remove_possibility(box1.value)}
        changes += 1
      end
      total_possibilities += box1.possibilities
    }
    if get_square(square).all? {|box| box.has_value}
      @unsolved_squares.delete(square)
    end
    get_square(square).each{|box|
      unless box.has_value
        get_unique_possibilities(total_possibilities).each{|num|
          if box.possibilities.include?(num)
            box.set_value(num)
            changes += 1
          end
        }
      end
    }
    changes
  end

  def is_valid_sudoku
    nums = [*1..9]
    nums.each {|num|
      row_values = []
      get_row(num).each {|row_box|
        if row_box.value > 0
          row_values.push(row_box.value)
        end }
      unless row_values.size === row_values.uniq.size
        return false
      end

      column_values = []
      get_column(num).each {|column_box|
        if column_box.value > 0
          column_values.push(column_box.value)
        end }
      unless column_values.size === column_values.uniq.size
        return false
      end

      square_values = []
      get_square(num).each {|square_box|
        if square_box.value > 0
          square_values.push(square_box.value)
        end }
      unless square_values.size === square_values.uniq.size
        return false
      end
    }
    true
  end

  def show_boxes
    @boxes.each{ |box| box.print_val}
  end

  def get_unique_possibilities(possibilities)
    unique_possibilities = []
    [*1..9].each{|num|
      if possibilities.select{|num2| num2 === num}.length === 1
        unique_possibilities.push(num)
      end}
    unique_possibilities
  end
end