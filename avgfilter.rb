require 'optparse'

options = {}

$window_size = 10.0
$tolerance = 1.0

optparse = OptionParser.new do |opts|
   opts.banner = "Usage: avgfilter.rb [options]"
 
   opts.on( '-w', '--window SIZE', 'window (buffer) size' ) do |v|
     $window_size = v.to_i
   end
   
   opts.on( '-t', '--tolerance VALUE', 'tolerance between two values' ) do |v|
     $tolerance = v.to_f
   end

   opts.on( '-h', '--help', 'Display this screen' ) do
     puts opts
     exit
   end
end

optparse.parse!

$total = 0.0
$buf = []
$output = []

def enqueue(value)
	abort "buffer overrun on #{value}" if $buf.length >= $window_size
	$buf << value
	$output << value
	$total += value
end

def dequeue
	value = $buf.shift
	out = $output.shift
	$total -= value
	
	outtext = '%.2f'%out
	puts outtext
end

$middle_index = $window_size / 2

def flush_buf
	# for the last few data after the middle
	#if $buf.length > $middle_index + 1
	#end
	
	while $buf.length > 0
		dequeue
	end
end



$<.each {|line|
	new_value = line.to_f
	if $buf.length > 0
		if ($buf[-1]-new_value).abs > $tolerance
			flush_buf
		elsif $buf.length == $window_size
			# update the output for the item in the middle of the buffer
			$output[$middle_index] = $total / $window_size
			
			# output the head of the buffer
			dequeue
		end
	end
	enqueue new_value
	if $buf.length > 1
		# for the first few data in the buffer
		$output[-1] = $total / $buf.length
	end
}

flush_buf
