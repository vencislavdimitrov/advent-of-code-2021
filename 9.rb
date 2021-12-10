input = File.read(File.basename(__FILE__).gsub('rb', 'input')).split("\n").map { _1.chars.map(&:to_i) }

def check(maze, x, y)
  (x + 1 >= maze.size || maze[x][y] < maze[x + 1][y]) &&
    (x - 1 < 0 || maze[x][y] < maze[x - 1][y]) &&
    (y + 1 >= maze[x].size || maze[x][y] < maze[x][y + 1]) &&
    (y - 1 < 0 || maze[x][y] < maze[x][y - 1])
end

sum = 0
(0...input.size).each do |i|
  (0...input[i].size).each do |j|
    sum += (input[i][j] + 1) if check(input, i, j)
  end
end
p sum

visited = {}
basins = {}
def dfs(input, i, j, visited, basins, basin)
  return unless i >= 0 && j >= 0 && i < input.size && j < input[i].size && input[i][j] < 9
  return if visited[[i, j]]

  visited[[i, j]] = true
  basins[basin] += 1
  dfs input, i - 1, j, visited, basins, basin
  dfs input, i + 1, j, visited, basins, basin
  dfs input, i, j - 1, visited, basins, basin
  dfs input, i, j + 1, visited, basins, basin
end

(0...input.size).each do |i|
  (0...input[i].size).each do |j|
    basins[[i, j]] = 0
    dfs input, i, j, visited, basins, [i, j]
  end
end
p basins.values.sort.last(3).inject(&:*)
