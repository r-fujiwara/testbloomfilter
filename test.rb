require 'bundler'
Bundler.require
require 'digest'

GEN_SIZE = ARGV.first.to_i rescue 150000
BITS_FILTER = 191702

$bf = BloomFilter::Native.new(:size => BITS_FILTER, :hashes => 13, :raise => false)

def gen_random_word(list, index)
  rand_word = Digest::SHA256.hexdigest(index.to_s)
  prev_length = list.length
  list << rand_word
  current_length = list.uniq.length
  if prev_length == current_length
    gen_random_word(list.uniq!)
  end
end

def random_unique_words(size)
  list = []
  index_list = (1..size).to_a
  Parallel.each(index_list, in_threads: 16) do |i|
    gen_random_word(list, i)
  end
  list
end

def affect_filter(list, method)
  Parallel.each(list, in_threads: 16) do |w|
    $bf.send method.to_sym, w
  end
end

unique_words = random_unique_words GEN_SIZE

puts "unique_words size....#{unique_words.length}"

affect_filter(unique_words, "insert")

other_words = random_unique_words GEN_SIZE

puts "counter unique words size...#{other_words.length}"

affect_filter(unique_words, "include?")

$bf.stats
