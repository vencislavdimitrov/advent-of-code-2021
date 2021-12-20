input = File.read(File.basename(__FILE__).gsub('rb', 'input'))
input = input.split("\n\n").map { _1.split("\n")[1..].map { |l| l.split(',').map(&:to_i) } }
scanners = input

def rotate(beacon)
  [
    [beacon[0], beacon[1], beacon[2]],
    [beacon[0], -beacon[1], -beacon[2]],
    [-beacon[0], beacon[1], -beacon[2]],
    [-beacon[0], -beacon[1], beacon[2]],
    [beacon[0], beacon[2], -beacon[1]],
    [-beacon[0], beacon[2], beacon[1]],
    [beacon[0], -beacon[2], beacon[1]],
    [-beacon[0], -beacon[2], -beacon[1]],

    [beacon[1], beacon[0], -beacon[2]],
    [beacon[1], -beacon[0], beacon[2]],
    [-beacon[1], beacon[0], beacon[2]],
    [-beacon[1], -beacon[0], -beacon[2]],
    [beacon[1], beacon[2], beacon[0]],
    [beacon[1], -beacon[2], -beacon[0]],
    [-beacon[1], beacon[2], -beacon[0]],
    [-beacon[1], -beacon[2], beacon[0]],

    [beacon[2], beacon[1], -beacon[0]],
    [-beacon[2], -beacon[1], -beacon[0]],
    [-beacon[2], beacon[0], -beacon[1]],
    [beacon[2], -beacon[0], -beacon[1]],
    [-beacon[2], beacon[1], beacon[0]],
    [beacon[2], -beacon[1], -beacon[0]],
    [beacon[2], beacon[0], beacon[1]],
    [-beacon[2], -beacon[0], beacon[1]]
  ]
end

diffs = []
while scanners.size > 1
  merged = []
  (0...scanners.size).each do |scanner1_id|
    (scanner1_id + 1...scanners.size).each do |scanner2_id|
      break if scanner2_id >= scanners.size
      next if merged.include?(scanner2_id)

      catch :merged do
        scanners[scanner1_id].each do |beacon1|
          rotated_scanner2_all = scanners[scanner2_id].map { rotate(_1) }
          (0...24).each do |rotation|
            rotated_scanner2 = rotated_scanner2_all.map { _1[rotation] }
            rotated_scanner2.each do |beacon2|
              diff = [beacon1[0] - beacon2[0], beacon1[1] - beacon2[1], beacon1[2] - beacon2[2]]

              translated_scanner2 = rotated_scanner2.map { [_1[0] + diff[0], _1[1] + diff[1], _1[2] + diff[2]] }

              next if (scanners[scanner1_id] & translated_scanner2).size < 12

              scanners[scanner1_id] = (scanners[scanner1_id] + translated_scanner2).uniq
              scanners.delete scanners[scanner2_id]
              merged << scanner2_id
              diffs << diff
              p "scanner1: #{scanner1_id}, scanner2: #{scanner2_id} - #{diff}, rotatation: #{rotation}, #{scanners[0].size}, #{beacon1}"
              throw :merged
            end
          end
        end
      end
    end
  end
end
p scanners[0].size

max = 0
diffs.combination(2).each do |s1, s2|
  max = [max, [(s1[0] - s2[0]).abs, (s1[1] - s2[1]).abs, (s1[2] - s2[2]).abs].sum].max
end
p max
