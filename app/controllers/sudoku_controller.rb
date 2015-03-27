class SudokuController < ApplicationController

  def solve
    render json: Sudoku.new(params[:boxes]).solve.show_boxes
  end
end
