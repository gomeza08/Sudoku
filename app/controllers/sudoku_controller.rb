class SudokuController < ApplicationController

  def solve
    Sudoku.new(params[:boxes])
  end
end
