input = File.read(File.basename(__FILE__).gsub('rb', 'input'))
input = input.split("\n")
p1 = input[0].chars.last.to_i
p2 = input[1].chars.last.to_i

def play1(p1, p2, s1, s2, die, rolls)
  return s2 *  rolls if s1 >= 1000
  return s1 *  rolls if s2 >= 1000

  new_p1 = (p1 + (3 * die + 3) - 1) % 10 + 1

  play1(p2, new_p1, s2, s1 + new_p1, die + 3, rolls + 3)
end

p play1 p1, p2, 0, 0, 1, 0

@memo = {}
@rolls = [1, 2, 3].repeated_permutation(3).map(&:sum)
def play2(p1, p2, s1, s2)
  return @memo[[p1, p2, s1, s2]] if @memo[[p1, p2, s1, s2]]

  return [1, 0] if s1 >= 21
  return [0, 1] if s2 >= 21

  res = [0, 0]
  @rolls.map do |roll|
    new_p1 = (p1 + roll - 1) % 10 + 1
    tmp = play2 p2, new_p1, s2, s1 + new_p1
    res[0] += tmp[1]
    res[1] += tmp[0]
  end

  @memo[[p1, p2, s1, s2]] = res
end

p play2(p1, p2, 0, 0).max
