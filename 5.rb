input = File.read(File.basename(__FILE__).gsub('rb', 'input')).lines.map(&:chomp)

def lines(a, b)
  if a[0] == b[0]
    ([a[1], b[1]].min..[a[1], b[1]].max).to_a.map { [a[0], _1] }
  else
    ([a[0], b[0]].min..[a[0], b[0]].max).to_a.map { [_1, a[1]] }
  end
end

def diag(a, b)
  res = []
  if a[0] < b[0]
    (a[0]..b[0]).each_with_index do |x, i|
      y = a[1] > b[1] ? a[1] - i : a[1] + i
      res << [x, y]
    end
  else
    (b[0]..a[0]).each_with_index do |x, i|
      y = b[1] > a[1] ? b[1] - i : b[1] + i
      res << [x, y]
    end
  end
  res
end

points = []
input.each do |point|
  a, b = point.split(' -> ').map { _1.split(',').map(&:to_i) }
  next unless a[0] == b[0] || a[1] == b[1]

  points += lines(a, b)
end

p points.inject(Hash.new(0)) { |h, e| h[e] += 1; h }.select { _2 >= 2 }.count

points = []
input.each do |point|
  a, b = point.split(' -> ').map { _1.split(',').map(&:to_i) }
  points +=
    if a[0] == b[0] || a[1] == b[1]
      lines a, b
    else
      diag a, b
    end
end

p points.inject(Hash.new(0)) { |h, e| h[e] += 1; h }.select { _2 >= 2 }.count
