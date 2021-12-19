input = File.read(File.basename(__FILE__).gsub('rb', 'input'))
input = input.split.map { eval(_1) }

def split(number)
  if number.is_a? Numeric
    return true, [number/2, (number + 1) / 2] if number >= 10

    return false, number
  end

  a, b = number
  changed, a = split a
  return [true, [a, b]] if changed

  changed, b = split b

  [changed, [a, b]]
end

def add_left(number, n)
  return number if n.nil?
  return number + n if number.is_a? Numeric

  [add_left(number[0], n), number[1]]
end

def add_right(number, n)
  return number if n.nil?
  return number + n if number.is_a? Numeric

  [number[0], add_right(number[1], n)]
end

def explode(number, l)
  return false, nil, number, nil if number.is_a? Numeric
  return true, number[0], 0, number[1] if l == 0

  a, b = number
  exploded, left, a, right = explode a, l - 1
  return true, left, [a, add_left(b, right)], nil if exploded

  exploded, left, b, right = explode b, l - 1
  return true, nil, [add_right(a, left), b], right if exploded

  [false, nil, number, nil]
end

def add(number1, number2)
  res = [number1, number2]
  loop do
    changed, _, res, = explode res, 4
    next if changed

    changed, res = split res
    break unless changed
  end
  res
end

def magnitude(number)
  return number if number.is_a? Numeric

  3 * magnitude(number[0]) + 2 * magnitude(number[1])
end

res = []
input.each do |line|
  if res.empty?
    res = line
    next
  end
  res = add res, line
end
p magnitude res

max_magnitude = 0
input.combination(2).each do |number1, number2|
  max_magnitude = [max_magnitude, magnitude(add(number1, number2))].max
  max_magnitude = [max_magnitude, magnitude(add(number2, number1))].max
end
p max_magnitude
