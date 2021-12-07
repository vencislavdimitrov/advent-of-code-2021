input = File.read(File.basename(__FILE__).gsub('rb', 'input')).split(',').map(&:to_i)

fish = input.inject(Hash.new(0)) { |h, e| h[e] += 1; h }

def breed(fish)
  fish[9] = fish[0] if fish[0]
  fish[0] = 0 unless fish[0]
  fish[0] += fish[7] if fish[7]
  fish.delete 7
  fish.transform_keys { _1.zero? ? 6 : _1 - 1 }
end

80.times do
  fish = breed fish
end

p fish.map { _2 }.sum

256.times do
  fish = breed fish
end

p fish.map { _2 }.sum
