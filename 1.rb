input = File.read('./1.input').split.map(&:to_i)

res = 0
input.each_cons(2).each do |pair|
  res += 1 if pair[0] < pair[1]
end
p res

res = 0
input.each_cons(4).each do |pair|
  res += 1 if [pair[0], pair[1], pair[2]].sum < [pair[1], pair[2], pair[3]].sum
end
p res
