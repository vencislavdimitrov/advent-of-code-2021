input = File.read(File.basename(__FILE__).gsub('rb', 'input'))
input = input.split("\n")

def room_pods(input, room)
  input[2...input.size - 1].map { _1[room] }
end

def win?(input)
  [3, 5, 7, 9].each do |room|
    return false if room_pods(input, room).any? { room(_1) != room }
  end

  true
end

def in_place(input, i, j)
  case input[i][j]
  when 'A'
    return j == 3 && i >= 2 && i < input.size - 1
  when 'B'
    return j == 5 && i >= 2 && i < input.size - 1
  when 'C'
    return j == 7 && i >= 2 && i < input.size - 1
  when 'D'
    return j == 9 && i >= 2 && i < input.size - 1
  end

  false
end

def blocked(input, i, j)
  return false if i < 3

  input[i - 1][j] != '.'
end

def blocking(input, i, j)
  (i + 1...input.size - 1).each do |k|
    return true if ['A', 'B', 'C', 'D'].include?(input[k][j]) && room(input[k][j]) != j
  end
  false
end

def can_move(input, i, j)
  (!in_place(input, i, j) || blocking(input, i, j)) && !blocked(input, i, j)
end

def is_room_free(input, i, j)
  case input[i][j]
  when 'A'
    return input[2][3] == '.' && input[3...input.size - 1].none? { _1[3] != '.' && _1[3] != 'A' }
  when 'B'
    return input[2][5] == '.' && input[3...input.size - 1].none? { _1[5] != '.' && _1[5] != 'B' }
  when 'C'
    return input[2][7] == '.' && input[3...input.size - 1].none? { _1[7] != '.' && _1[7] != 'C' }
  when 'D'
    return input[2][9] == '.' && input[3...input.size - 1].none? { _1[9] != '.' && _1[9] != 'D' }
  end

  false
end

def room(pod)
  {
    'A' => 3,
    'B' => 5,
    'C' => 7,
    'D' => 9
  }[pod]
end

def is_path_free(input, i, j, target)
  return false if i == 3 && input[2][j] != '.'
  range = ([target, j].min..[target, j].max).to_a - [j]
  range.all? { input[1][_1] == '.' }
end

def is_in_room(input, i, j)
  i > 1
end

def room_position(input, room)
  (2...input.size - 1).reverse_each do |k|
    return k if input[k][room] == '.'
  end

  false
end

def cost(pod)
  {
    'A' => 1,
    'B' => 10,
    'C' => 100,
    'D' => 1000
  }[pod]
end

def path_cost(input, i, j, new_i, new_j)
  ((i - 1) + (j - new_j).abs + (new_i - 1)) * cost(input[new_i][new_j])
end

def stoppable_positions
  [1, 2, 4, 6, 8, 10, 11]
end

@memo = {}
def move(input)
  return @memo[input] if @memo[input]

  return 0 if win?(input)

  costs = []
  (1...input.size).each do |i|
    (1...input[i].size).each do |j|
      next unless ['A', 'B', 'C', 'D'].include? input[i][j]
      next unless can_move(input, i, j)

      if is_room_free(input, i, j) && is_path_free(input, i, j, room(input[i][j]))
        new_input = input.map(&:dup)
        pod = new_input[i][j]
        new_j = room pod
        new_i = room_position(input, new_j)
        new_input[new_i][new_j] = pod
        new_input[i][j] = '.'

        cost = move(new_input)
        costs << (path_cost(new_input, i, j, new_i, new_j) + cost) if cost >= 0
      elsif is_in_room(input, i, j)
        stoppable_positions.each do |s|
          next unless is_path_free(input, i, j, s)

          new_input = input.map(&:dup)
          pod = new_input[i][j]
          new_input[1][s] = pod
          new_input[i][j] = '.'

          cost = move(new_input)
          costs << (path_cost(new_input, i, j, 1, s) + cost) if cost >= 0
        end
      end
    end
  end

  res = (costs.min || -1)
  @memo[input] = res
  res
end

p move input

input.insert 3, '  #D#C#B#A#  '
input.insert 4, '  #D#B#A#C#  '

p move input
