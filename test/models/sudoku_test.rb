require File.dirname(__FILE__) + '/../test_helper'
class SudokuTest < ActiveSupport::TestCase

  test 'test init' do
    test_sudoku = Sudoku.new([3,0,0,0,0,4,0,2,0,
                             1,4,0,0,9,0,3,0,7,
                             8,9,7,0,0,2,1,0,0,
                             0,5,8,7,4,0,0,0,0,
                             0,0,0,3,0,1,0,0,0,
                             0,0,0,0,5,8,7,4,0,
                             0,0,9,4,0,0,6,7,3,
                             5,0,6,0,8,0,0,1,2,
                             0,1,0,6,0,0,0,0,9])
    assert_equal(81, test_sudoku.boxes.length)
    assert_equal(27, test_sudoku.unsolved_columns.length+test_sudoku.unsolved_rows.length+test_sudoku.unsolved_squares.length)
  end

  test 'test check row' do
    test_sudoku = Sudoku.new([3,0,0,0,0,4,0,2,0,
                             1,4,0,0,9,0,3,0,7,
                             8,9,7,0,0,2,1,0,0,
                             0,5,8,7,4,0,0,0,0,
                             0,0,0,3,0,1,0,0,0,
                             0,0,0,0,5,8,7,4,0,
                             0,0,9,4,0,0,6,7,3,
                             5,0,6,0,8,0,0,1,2,
                             0,1,0,6,0,0,0,0,9])
    assert_equal(true, test_sudoku.get_row(1)[1].possibilities.include?(2))
    test_sudoku.check_row(1)
    assert_equal(true, !test_sudoku.get_row(1)[0].possibilities.include?(2))
  end

  test 'test check col' do
    test_sudoku = Sudoku.new([3,0,0,0,0,4,0,2,0,
                             1,4,0,0,9,0,3,0,7,
                             8,9,7,0,0,2,1,0,0,
                             0,5,8,7,4,0,0,0,0,
                             0,0,0,3,0,1,0,0,0,
                             0,0,0,0,5,8,7,4,0,
                             0,0,9,4,0,0,6,7,3,
                             5,0,6,0,8,0,0,1,2,
                             0,1,0,6,0,0,0,0,9])
    assert_equal(true, test_sudoku.get_column(1)[4].possibilities.include?(1))
    test_sudoku.check_column(1)
    assert_equal(true, !test_sudoku.get_column(1)[4].possibilities.include?(1))
  end

  test 'test check square' do
    test_sudoku = Sudoku.new([3,0,0,0,0,4,0,2,0,
                              1,4,0,0,9,0,3,0,7,
                              8,9,7,0,0,2,1,0,0,
                              0,5,8,7,4,0,0,0,0,
                              0,0,0,3,0,1,0,0,0,
                              0,0,0,0,5,8,7,4,0,
                              0,0,9,4,0,0,6,7,3,
                              5,0,6,0,8,0,0,1,2,
                              0,1,0,6,0,0,0,0,9])
    assert_equal(true, test_sudoku.get_square(1)[1].possibilities.include?(1))
    test_sudoku.check_square(1)
    assert_equal(true, !test_sudoku.get_square(1)[1].possibilities.include?(1))
  end

  test 'test solve non ambiguous' do
    test_sudoku = Sudoku.new([3,0,0,0,0,4,0,2,0,
                              1,4,0,0,9,0,3,0,7,
                              8,9,7,0,0,2,1,0,0,
                              0,5,8,7,4,0,0,0,0,
                              0,0,0,3,0,1,0,0,0,
                              0,0,0,0,5,8,7,4,0,
                              0,0,9,4,0,0,6,7,3,
                              5,0,6,0,8,0,0,1,2,
                              0,1,0,6,0,0,0,0,9])
    assert_equal(true, test_sudoku.unsolved)
    test_sudoku.solve
    assert_equal(false, test_sudoku.unsolved)
    assert_equal(true, test_sudoku.is_valid_sudoku)
  end

  test 'test solve ambiguous' do
    test_sudoku = Sudoku.new([0,0,0,0,0,0,9,0,1,
                              0,9,0,0,0,5,0,8,0,
                              0,8,0,0,0,6,0,4,2,
                              6,0,4,0,0,2,0,0,0,
                              9,0,0,0,0,0,0,0,4,
                              0,0,0,5,0,0,8,0,6,
                              7,3,0,4,0,0,0,9,0,
                              0,4,0,3,0,0,0,1,0,
                              1,0,5,0,0,0,0,0,0])
    assert_equal(true, test_sudoku.unsolved)
    test_sudoku.solve
    assert_equal(false, test_sudoku.unsolved)
    assert_equal(true, test_sudoku.is_valid_sudoku)
    test_sudoku.show_boxes
  end

  test 'test valid' do
    test_sudoku = Sudoku.new([3,6,5,1,7,4,9,2,8,
                              1,4,2,8,9,6,3,5,7,
                              8,9,7,5,3,2,1,6,4,
                              6,5,8,7,4,9,2,3,1,
                              7,2,4,3,6,1,8,9,5,
                              9,3,1,2,5,8,7,4,6,
                              2,8,9,4,1,5,6,7,3,
                              5,7,6,9,8,3,4,1,2,
                              4,1,3,6,2,7,5,8,9])
    assert_equal(true, test_sudoku.is_valid_sudoku)
  end

  test 'test valid 2' do
    test_sudoku = Sudoku.new([3,3,5,1,7,4,9,2,8,
                              1,4,2,8,9,6,3,5,7,
                              8,9,7,5,3,2,1,6,4,
                              6,5,8,7,4,9,2,3,1,
                              7,2,4,3,6,1,8,9,5,
                              9,3,1,2,5,8,7,4,6,
                              2,8,9,4,1,5,6,7,3,
                              5,7,6,9,8,3,4,1,2,
                              4,1,3,6,2,7,5,8,9])
    assert_equal(false, test_sudoku.is_valid_sudoku)
  end
end