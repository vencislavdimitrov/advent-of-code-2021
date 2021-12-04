input = File.read(File.basename(__FILE__).gsub('rb', 'input')).split("\n")

mcb = ''
lcb = ''
(0...input[0].length).each do |i|
  bits = input.map { _1[i] }.inject(Hash.new(0)) { |h, e| h[e] += 1; h }
  if bits['0'] > bits['1']
    mcb += '0'
    lcb += '1'
  else
    mcb += '1'
    lcb += '0'
  end
end

p mcb.to_i(2) * lcb.to_i(2)

ox = input.clone
co = input.clone
(0...input[0].length).each do |i|
  break if ox.size == 1 && co.size == 1

  ox_bits = ox.map { _1[i] }.inject(Hash.new(0)) { |h, e| h[e] += 1; h }
  co_bits = co.map { _1[i] }.inject(Hash.new(0)) { |h, e| h[e] += 1; h }

  if ox.size > 1
    ox =
      if ox_bits['0'] > ox_bits['1']
        ox.select { _1[i] == '0' }
      else
        ox.select { _1[i] == '1' }
      end
  end

  if co.size > 1
    co =
      if co_bits['0'] > co_bits['1']
        co.select { _1[i] == '1' }
      else
        co.select { _1[i] == '0' }
      end
  end
end

p ox[0].to_i(2) * co[0].to_i(2)
