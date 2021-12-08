input = File.read(File.basename(__FILE__).gsub('rb', 'input')).split(',').map(&:to_i)

fuel = {}
(input.min..input.max).each do |i|
  fuel[i] = input.map { (_1 - i).abs }.sum
end

p fuel.values.min

fuel = {}
(input.min..input.max).each do |i|
  fuel[i] = input.map { (_1 - i).abs * ((_1 - i).abs + 1) / 2 }.sum
end

p fuel.values.min
