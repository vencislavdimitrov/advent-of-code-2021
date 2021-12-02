input = File.read(File.basename(__FILE__).gsub('rb', 'input')).split("\n")

pos = 0
depth = 0
input.each do |i|
  command, x = i.split
  case command
  when 'forward'
    pos += x.to_i
  when 'down'
    depth += x.to_i
  else
    depth -= x.to_i
  end
end

p pos * depth

pos = 0
depth = 0
aim = 0
input.each do |i|
  command, x = i.split
  case command
  when 'forward'
    pos += x.to_i
    depth += aim * x.to_i
  when 'down'
    aim += x.to_i
  else
    aim -= x.to_i
  end
end

p pos * depth
