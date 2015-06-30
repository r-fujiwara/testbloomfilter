require 'bundler'
Bundler.require
require 'digest'

FILTER_SIZE = ARGV.first.to_i rescue 150000

$bf = BloomFilter::Native.new(:size => FILTER_SIZE, :hashes => 13, :raise => false)

def gen_random_word(list, method, index)
  rand_word = Digest::SHA256.hexdigest(index.to_s)
  prev_length = list.length
  list << rand_word
  current_length = list.uniq.length
  if prev_length == current_length
    puts "********duplicate!...#{rand_word}***********"
    gen_random_word(list.uniq!)
  else
    puts "#{method}...#{rand_word}"
    $bf.send method.to_sym, rand_word
  end
end

def set_random_unique_words(size, method)
  list = []
  index_list = (1..size).to_a
  Parallel.each(index_list, in_threads: 16) do |i|
  #size.times do |i|
    puts "index...#{i}"
    gen_random_word(list, method, i)
  end
end

set_random_unique_words FILTER_SIZE, 'insert'

set_random_unique_words FILTER_SIZE, 'include?'

$bf.stats
