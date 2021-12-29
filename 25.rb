input = File.read(File.basename(__FILE__).gsub('rb', 'input'))
input = input.split("\n")

def move_south(input, i, j)
  return [(i + 1) % input.size, j] if input[i][j] == 'v' && input[(i + 1) % input.size][j] == '.'

  false
end

def move_east(input, i, j)
  return [i, (j + 1) % input[i].size] if input[i][j] == '>' && input[i][(j + 1) % input[i].size] == '.'

  false
end

iterations = 0
moved = true
while moved
  moved = false
  iterations += 1
  new_input = input.map(&:dup)
  (0...input.size).each do |i|
    (0...input[i].size).each do |j|
      next unless new_place = move_east(input, i, j)

      moved = true
      new_input[new_place[0]][new_place[1]], new_input[i][j] = new_input[i][j], new_input[new_place[0]][new_place[1]]
    end
  end
  input = new_input.map(&:dup)
  (0...input.size).each do |i|
    (0...input[i].size).each do |j|
      next unless new_place = move_south(input, i, j)

      moved = true
      new_input[new_place[0]][new_place[1]], new_input[i][j] = new_input[i][j], new_input[new_place[0]][new_place[1]]
    end
  end
  input = new_input
end
p iterations
