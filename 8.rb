input = File.read(File.basename(__FILE__).gsub('rb', 'input')).split("\n")

p input.map { _1.split('|')[1] }.map(&:split).map { _1.count { |a| [2, 4, 3, 7].include?(a.length) }}.sum

sum = 0
input.each do |line|
  input, output = line.split('|').map(&:split)
  digits = []
  digits[1] = input.find { _1.length == 2 }
  digits[7] = input.find { _1.length == 3 }
  digits[4] = input.find { _1.length == 4 }
  digits[8] = input.find { _1.length == 7 }

  zero_nine_six = input.select { _1.length == 6 }
  two_three_five = input.select { _1.length == 5 }

  digits[6] = zero_nine_six.find { !(digits[1].chars - _1.chars).empty? }
  digits[9] = zero_nine_six.find { (digits[4].chars - _1.chars).empty? }
  digits[0] = zero_nine_six.find { _1 != digits[6] && _1 != digits[9] }
  digits[3] = two_three_five.find { (digits[1].chars - _1.chars).empty? }
  digits[5] = two_three_five.find { _1 != digits[3] && (_1.chars - digits[6].chars).empty? }
  digits[2] = two_three_five.find { _1 != digits[3] && _1 != digits[5] }

  digits = digits.map { _1.chars.sort.join }
  sum += output.map { _1.chars.sort.join }.map { digits.index(_1) }.join.to_i
end
p sum
