input = File.read(File.basename(__FILE__).gsub('rb', 'input'))
input = input.chars

bin = input.map { _1.hex.to_s(2).rjust(_1.size * 4, '0') }.join

def decode(bin, start, version)
  version += bin[start, 3].to_i(2)
  start += 3
  type_id = bin[start, 3].to_i(2)
  start += 3

  subpackets = []
  if type_id == 4
    subpackets << ''
    leading_bit = '1'
    while leading_bit == '1'
      literal = bin[start, 5]
      leading_bit = literal[0]
      subpackets[0] << literal[1, 4]
      start += 5
    end
  else
    length_id = bin[start, 1]
    start += 1
    if length_id == '0'
      bit_length = bin[start, 15].to_i(2)
      start += 15
      target_start = start + bit_length
      while start < target_start
        start, version, subpacket = decode(bin, start, version)
        subpackets << subpacket
      end
    else
      num_children = bin[start, 11].to_i(2)
      start += 11
      num_children.times do
        start, version, subpacket = decode(bin, start, version)
        subpackets << subpacket
      end
    end
  end

  value =
    case type_id
    when 0
      subpackets.sum
    when 1
      subpackets.inject(:*)
    when 2
      subpackets.min
    when 3
      subpackets.max
    when 4
      subpackets[0].to_i(2)
    when 5
      subpackets[0] > subpackets[1] ? 1 : 0
    when 6
      subpackets[0] < subpackets[1] ? 1 : 0
    when 7
      subpackets[0] == subpackets[1] ? 1 : 0
    end
  [start, version, value]
end

start, version, value = decode(bin, 0, 0)
p version
p value
