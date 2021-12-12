input = File.read(File.basename(__FILE__).gsub('rb', 'input')).split("\n")

points1 = {
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25_137
}
points2 = {
  ')' => 1,
  ']' => 2,
  '}' => 3,
  '>' => 4
}

brackets_map = {
  '(' => ')',
  '[' => ']',
  '{' => '}',
  '<' => '>'
}

res1 = 0
res2 = []
input.each do |line|
  brackets = []

  line.chars.each do |c|
    case c
    when *brackets_map.keys
      brackets << c
    when *brackets_map.values
      if brackets_map[brackets.last] != c
        res1 += points1[c]
        brackets = []
        break
      end
      brackets.pop
    end
  end
  if brackets.any?
    res2 << 0
    brackets.reverse.each { res2[res2.size - 1] = res2.last * 5 + points2[brackets_map[_1]] }
  end
end
p res1
p res2.sort[res2.size / 2]
