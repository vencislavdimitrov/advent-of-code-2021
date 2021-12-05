input = File.read(File.basename(__FILE__).gsub('rb', 'input')).split("\n\n")

numbers = input.first.split(',').map(&:to_i)
boards = input[1..].map { _1.split("\n").map { |l| l.split.map(&:to_i) } }

def check_board(board)
  board.each do |line|
    return true if line.all? { _1 == 'x' }
  end
  (0...board.size).each do |i|
    return true if board.map { _1[i] }.all? { _1 == 'x' }
  end
  false
end

def sum_board(board)
  sum = 0
  board.each do |line|
    line.each do |n|
      sum += n if n != 'x'
    end
  end
  sum
end

winning_board = 0
winning_number = 0
catch :bingo do
  numbers.each do |number|
    (0...boards.size).each do |board|
      (0...boards[board].size).each do |i|
        (0...boards[board][i].size).each do |j|
          boards[board][i][j] = 'x' if boards[board][i][j] == number

          next unless check_board boards[board]

          winning_board = board
          winning_number = number
          p sum_board(boards[winning_board]) * winning_number
          throw :bingo
        end
      end
    end
  end
end

winning_board = {}
catch :bingo do
  numbers.each do |number|
    (0...boards.size).each do |board|
      (0...boards[board].size).each do |i|
        (0...boards[board][i].size).each do |j|
          boards[board][i][j] = 'x' if boards[board][i][j] == number

          winning_board[board] = true if check_board(boards[board])

          if winning_board.size == boards.size
            p sum_board(boards[board]) * number
            throw :bingo
          end
        end
      end
    end
  end
end
