require 'bundler'
Bundler.require
require 'digest'

GEN_SIZE = ARGV.first.to_i rescue 150000
BITS_FILTER = 191702

$bf = BloomFilter::Native.new(:size => BITS_FILTER, :hashes => 13, :raise => false)

def gen_random_word(hash, index)
  rand_word = Digest::SHA256.hexdigest(index.to_s)
  if hash.key? rand_word
    gen_random_word(hash, index)
  else
    hash[rand_word] = nil
  end
end

def random_unique_words(size, offset:)
  hash = {}
  size.times do |i|
    ii = i + offset
    gen_random_word(hash, ii)
  end
  hash
end

def affect_filter(list, method)
  list.each do |w|
    $bf.send method.to_sym, w
  end
end

unique_words = random_unique_words GEN_SIZE, offset: 0

puts "unique_words size....#{unique_words.length}"

affect_filter(unique_words.keys, "insert")

other_words = random_unique_words GEN_SIZE, offset: GEN_SIZE

puts "counter unique words size...#{other_words.length}"

num = 0
other_words.each do |k, v|
  if $bf.include? k
    if unique_words.key? k
      puts "include...#{k}"
    else
      num += 1
      puts "false positive..#{k}"
    end
  end
end

puts "false positive number ....#{num}"
sleep 1
$bf.stats
