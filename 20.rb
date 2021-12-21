input = File.read(File.basename(__FILE__).gsub('rb', 'input'))
alg, input = input.split("\n\n")
input = input.split

def add_black(input, black = '.', ext = 4)
  w = input[0].size + ext * 2
  new_input = input.map { _1.center w, black }

  empty_line = (black * w)

  [*([empty_line] * ext), *new_input, *([empty_line] * ext)]
end

def print(input)
  puts ''
  input.map { puts _1 }
  puts ''
end

def enchance(pixels, alg)
  alg[pixels.join.chars.map { _1 == '#' ? 1 : 0 }.join.to_i(2)]
end

def calculate(input, alg, n)
  black = '.'
  n.times do
    input = add_black input, black
    # print input
    new_input = []
    (2...input.size - 2).each do |i|
      new_input << []
      (2...input[i].size - 2).each do |j|
        new_input[i - 2] << enchance(
          [
            input[i - 1][j - 1], input[i - 1][j], input[i - 1][j + 1],
            input[i][j - 1], input[i][j], input[i][j + 1],
            input[i + 1][j - 1], input[i + 1][j], input[i + 1][j + 1]
          ],
          alg
        )
      end
      new_input[i - 2] = new_input[i - 2].join
    end
    input = new_input
    black = input[0][0]
  end
  input.map { _1.count('#') }.sum
end

p calculate input, alg, 2
p calculate input, alg, 50
