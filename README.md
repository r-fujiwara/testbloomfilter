# testbloomfilter

[このサンプル](https://github.com/igrigorik/bloomfilter-rb/blob/master/examples/simple-native.rb)と、[こちら](http://hur.st/bloomfilter?n=150000&p=1.0E-4)ののリンクにしたがって、
みると、15万のフィルターに対して、Hashが13個の入力に対して、1万分の1の確率で間違いが起こることが発見出来るはずである

以下のようなサンプルとstatsが得られる

```rb
#!/usr/bin/env ruby
require 'bloomfilter-rb'

WORDS = %w(duck penguin bear panda)
TEST = %w(penguin moose racooon)

bf = BloomFilter::Native.new(:size => 100, :hashes => 2, :seed => 1, :bucket => 3, :raise => false)

WORDS.each { |w| bf.insert(w) }
TEST.each do |w|
  puts "#{w}: #{bf.include?(w)}"
end

bf.stats

#  penguin: true
#  moose: false
#  racooon: false
#
#  Number of filter buckets (m): 100
#  Number of bits per buckets (b): 1
#  Number of filter elements (n): 4
#  Number of filter hashes (k) : 4
#  Raise on overflow? (r) : false
#  Predicted false positive rate = 0.05%
```
