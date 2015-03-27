class SudokuController < ApplicationController

  def solve
    puzzle = Sudoku.new(params[:boxes])
    puzzle.solve
    render json: {:initial => puzzle.initial, :solution => puzzle.show_boxes}
  end
end
