input = File.read(File.basename(__FILE__).gsub('rb', 'input'))
input = input.split("\n").map { _1.chars.map(&:to_i) }

class PriorityQueue
  attr_reader :elements

  def initialize(size)
    @elements = [nil]
    @indexes = Array.new(size) { Array.new(size, 0) }
  end

  def <<(element)
    if @indexes[element[0][0]][element[0][1]] > 0
      el_index = @indexes[element[0][0]][element[0][1]]
      if @elements[el_index][1] > element[1]
        @elements[el_index][1] = element[1]
        bubble_up el_index
      else
        @elements[el_index][1] = element[1]
        bubble_down el_index
      end
    else
      @elements << element
      @indexes[element[0][0]][element[0][1]] = @elements.size - 1
      bubble_up(@elements.size - 1)
    end
  end

  def pop
    exchange(1, @elements.size - 1)
    max = @elements.pop[0]
    @indexes[max[0]][max[1]] = 0
    bubble_down(1)
    max
  end

  private

  def bubble_up(index)
    parent_index = (index / 2)

    return if index <= 1
    return if @elements[parent_index][1] <= @elements[index][1]

    exchange(index, parent_index)
    bubble_up(parent_index)
  end

  def bubble_down(index)
    child_index = (index * 2)

    return if child_index > @elements.size - 1

    not_the_last_element = child_index < @elements.size - 1
    left_element = @elements[child_index] && @elements[child_index][1]
    right_element = @elements[child_index + 1] && @elements[child_index + 1][1]
    child_index += 1 if not_the_last_element && right_element < left_element

    return if @elements[index][1] <= @elements[child_index][1]

    exchange(index, child_index)
    bubble_down(child_index)
  end

  def exchange(source, target)
    @elements[source], @elements[target] = @elements[target], @elements[source]
    a = @elements[source][0]
    b = @elements[target][0]
    @indexes[a[0]][a[1]], @indexes[b[0]][b[1]] = @indexes[b[0]][b[1]], @indexes[a[0]][a[1]]
  end
end

def neighbours(input, current, dist)
  [
    [current[0] - 1, current[1]],
    [current[0], current[1] - 1],
    [current[0] + 1, current[1]],
    [current[0], current[1] + 1]
  ].select do |step|
    step[0] >= 0 && step[0] < input.size && step[1] >= 0 && step[1] < input[0].size && dist[step[0]][step[1]] > 0
  end
end

def dijkstra(input, start, finish)
  dist = Array.new(input.size) { Array.new(input[0].size, Float::INFINITY) }
  dist[0][0] = 0
  visited = Array.new(input.size) { Array.new(input[0].size, 0) }
  unvisited = PriorityQueue.new input.size
  unvisited << [start, 0]

  while unvisited.elements.any?
    current = unvisited.pop

    neighbours(input, current, dist).each do |step|
      alt_diff = input[step[0]][step[1]]
      if alt_diff + dist[current[0]][current[1]] < dist[step[0]][step[1]]
        dist[step[0]][step[1]] = alt_diff + dist[current[0]][current[1]]
        (neighbours(input, step, dist) + [step]).each do |node|
          unvisited << [node, dist[node[0]][node[1]]]
        end
      else
        unvisited << [step, dist[step[0]][step[1]]] unless visited[step[0]][step[1]] == 1
      end
    end

    visited[current[0]][current[1]] = 1
  end
  dist[finish[0]][finish[1]]
end

p dijkstra(input, [0, 0], [input.size - 1, input[0].size - 1])

new_input = []
ii = 0
5.times do |jj|
  (0...input.size).each do |i|
    new_input << []
    5.times do |j|
      new_input[ii * input.size + i] += input[i].map { (_1 + j + jj - 1) % 9 + 1 }
    end
  end
  ii += 1
end

p dijkstra(new_input, [0, 0], [new_input.size - 1, new_input[0].size - 1])
