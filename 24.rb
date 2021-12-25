input = File.read(File.basename(__FILE__).gsub('rb', 'input'))
input = input.split("\n").map(&:split)

i = -1
inputs = {}
input.each do |inp|
  i += 1 if inp[0] == 'inp'
  (inputs[i] ||= []) << inp
end

def check_monad(input, n, z = 0)
  inp_indx = 0
  vars = {
    'w' => 0,
    'x' => 0,
    'y' => 0,
    'z' => z
  }
  input.each do |ins_str|
    ins, a, b = ins_str

    rhs = b.to_i.to_s == b ? b.to_i : vars[b]
    case ins
    when 'inp'
      vars[a] = n[inp_indx]
      inp_indx += 1
    when 'add'
      vars[a] = vars[a].to_i + rhs
    when 'mul'
      vars[a] = vars[a].to_i * rhs
    when 'div'
      vars[a] = vars[a].to_i / rhs
    when 'mod'
      vars[a] = vars[a].to_i % rhs
    when 'eql'
      vars[a] = vars[a].to_i == rhs ? 1 : 0
    end
  end

  vars['z']
end

monad_map = {}
14.times do |i|
  monad_map[i] = {}
  (1..9).each do |n|
    if monad_map[i - 1].nil?
      monad_map[i][check_monad(inputs[i], [n], 0)] = [n, 0]
    else
      monad_map[i - 1].each do |k, v|
        monad_map[i][check_monad(inputs[i], [n], k)] = [n, k]
      end
    end
  end
  p monad_map[i].size
end

number = [monad_map[13][0]]
(0...13).reverse_each do |i|
  number << monad_map[i][number.last[1]]
end
puts number.map(&:first).reverse.join

monad_map = {}
14.times do |i|
  monad_map[i] = {}
  (1..9).reverse_each do |n|
    if monad_map[i - 1].nil?
      monad_map[i][check_monad(inputs[i], [n], 0)] = [n, 0]
    else
      monad_map[i - 1].each do |k, v|
        monad_map[i][check_monad(inputs[i], [n], k)] = [n, k]
      end
    end
  end
  p monad_map[i].size
end

number = [monad_map[13][0]]
(0...13).reverse_each do |i|
  number << monad_map[i][number.last[1]]
end
puts number.map(&:first).reverse.join
