input = File.read(File.basename(__FILE__).gsub('rb', 'input'))
input = input.split
x_area = input[2].gsub(',', '').gsub('x=', '').split('..').map(&:to_i)
y_area = input[3].gsub('y=', '').split('..').map(&:to_i)

def steps(x, y, x_area, y_area)
  steps = [[0, 0]]
  loop do
    new_step = [0, 0]
    new_step[0] = steps.last[0] + x
    new_step[1] = steps.last[1] + y
    x = x == 0 ? 0 : ( x > 0 ? x - 1 : x + 1)
    y -= 1
    steps << new_step
    break if in_area(x_area, y_area, new_step)
    break if y < y_area[0]
  end

  steps
end

def in_area(x_area, y_area, point)
  (x_area[0]..x_area[1]).include?(point[0]) && (y_area[0]..y_area[1]).include?(point[1])
end

max = 0
count = 0
(0..100).each do |i|
  (-200..200).each do |j|
    steps = steps(i, j, x_area, y_area)
    if in_area(x_area, y_area, steps.last)
      max = [max, steps.map {_1[1]}.max].max
      count += 1
    end
  end
end
p max
p count
