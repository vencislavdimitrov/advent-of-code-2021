input = File.read(File.basename(__FILE__).gsub('rb', 'input'))
input = input.split("\n")

connections = {}
input.map { _1.split('-') }.each do |l, r|
  (connections[l] ||= []) << r
  (connections[r] ||= []) << l
end

paths = []
def dfs(connections, paths, current = 'start', visited = [])
  return visited if current == 'end'

  connections[current].reject { _1 == _1.downcase && visited.include?(_1) }.each do |c|
    res = dfs connections, paths, c, visited + [current]
    paths << res if res != false
  end
  false
end

dfs(connections, paths)
p paths.size

paths = []
def dfs(connections, paths, current = 'start', visited = [], double_visited = false)
  return visited if current == 'end'

  connections[current].reject { _1 == _1.downcase && visited.include?(_1) && double_visited || _1 == 'start' }.each do |c|
    current_double_visited = double_visited || c == c.downcase && visited.include?(c) && c != 'end'
    res = dfs connections, paths, c, visited + [current], current_double_visited
    paths << res if res != false
  end
  false
end

dfs(connections, paths)
p paths.size
