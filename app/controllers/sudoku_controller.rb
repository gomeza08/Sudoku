class SudokuController < ApplicationController

  attr_accessor :sudoku

  def initialize(sudoku)
    @sudoku = sudoku
  end
end
