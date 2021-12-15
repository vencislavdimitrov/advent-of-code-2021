input = File.read(File.basename(__FILE__).gsub('rb', 'input'))
polymer, rules = input.split("\n\n")
rules = rules.split("\n").map { _1.split ' -> ' }

rules = rules.to_h
polymer1 = polymer
10.times do
  polymer1 = polymer1.chars.each_cons(2).map { _1 + rules[_1 + _2] }.join + polymer1.chars.last
end

elements = polymer1.chars.tally
p elements.values.max - elements.values.min

pairs = {}
polymer.chars.each_cons(2) { pairs[_1 + _2] ||= 0; pairs[_1 + _2] += 1 }
40.times do
  new_pairs = pairs.dup
  pairs = {}
  new_pairs.each do |pair, count|
    new_element = rules[pair]
    next unless new_element

    pairs[pair[0] + new_element] ||= 0
    pairs[pair[0] + new_element] += count
    pairs[new_element + pair[1]] ||= 0
    pairs[new_element + pair[1]] += count
  end
end
res = { polymer.chars.last => 1 }
pairs.map { res[_1[0]] ||= 0; res[_1[0]] += _2 }

p res.values.max - res.values.min
