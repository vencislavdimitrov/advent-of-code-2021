input = File.read(File.basename(__FILE__).gsub('rb', 'input')).split("\n").map { _1.chars.map(&:to_i) }

init_data = input.map(&:clone)

def neighbours(input, i, j)
  [
    [i + 1, j],
    [i + 1, j + 1],
    [i + 1, j - 1],
    [i, j + 1],
    [i, j - 1],
    [i - 1, j],
    [i - 1, j + 1],
    [i - 1, j - 1]
  ].select { (0...input.size).include?(_1[0]) && (0...input[_1[0]].size).include?(_1[1]) }.uniq
end

def flash(input, i, j)
  flashed = 1
  neighbours(input, i, j).each do |n|
    input[n[0]][n[1]] += 1
    flashed += flash(input, n[0], n[1]) if input[n[0]][n[1]] == 10
  end
  flashed
end

flashes = 0
100.times do
  (0...input.size).each do |i|
    (0...input[i].size).each do |j|
      input[i][j] += 1
      flashes += flash(input, i, j) if input[i][j] == 10
    end
  end
  (0...input.size).each do |i|
    (0...input[i].size).each do |j|
      input[i][j] = 0 if input[i][j] > 9
    end
  end
end
p flashes

input = init_data
1000.times do |step|
  flashes = 0
  (0...input.size).each do |i|
    (0...input[i].size).each do |j|
      input[i][j] += 1
      flashes += flash(input, i, j) if input[i][j] == 10
    end
  end
  (0...input.size).each do |i|
    (0...input[i].size).each do |j|
      input[i][j] = 0 if input[i][j] > 9
    end
  end

  if flashes == input.size * input[0].size
    p step + 1
    break
  end
end
