require 'benchmark/ips'
require 'set'
require 'socket'

# Grug store past brain thoughts for quick remember
class MemoizedFibonacci
  def initialize
    @memo = {}
  end

  def fib(n)
    return n if n < 2
    @memo[n] ||= fib(n - 1) + fib(n - 2)
  end
end

# Grug think hard every time, no remember past
class NaiveFibonacci
  def fib(n)
    return n if n < 2
    fib(n - 1) + fib(n - 2)
  end
end

# Grug ask many caves at once, fast
class ConcurrentDNSLookup
  def resolve(hostnames)
    threads = hostnames.map do |hostname|
      Thread.new { Socket.getaddrinfo(hostname, nil) }
    end
    threads.map(&:join)  # Grug wait all answers come back
  end
end

# Grug ask one cave at time, slow
class NaiveDNSLookup
  def resolve(hostnames)
    hostnames.map do |hostname|
      Socket.getaddrinfo(hostname, nil)
    end
  end
end

# Grug smart, remember past transforms
class MemoizedProtocolTransformer
  attr_reader :foo_data, :bar_data

  def initialize(foo_data)
    @foo_data = foo_data
    @bar_data = ""
  end

  def transform
    add_metadata
    @bar_data += @foo_data["interesting_data"].reverse
  end

  private

  def add_metadata
    version_info = calculate_version_info
    length_info = calculate_length_info
    @bar_bar = "Version: #{version_info} Length: #{length_info} Data: "
  end

  def calculate_version_info
    fib_instance = MemoizedFibonacci.new
    fib_instance.fib(@foo_data["version"])
  end

  def calculate_length_info
    @foo_data["interesting_data"].chars.map(&:ord).sum
  end
end

# Grug do everything fresh, no remember
class NaiveProtocolTransformer
  attr_reader :foo_data, :bar_data

  def initialize(foo_data)
    @foo_data = foo_data
    @bar_data = ""
  end

  def transform
    add_metadata
    @bar_data += @foo_data["interesting_data"].reverse
  end

  private

  def add_metadata
    version_info = calculate_version_info
    length_info = calculate_length_info
    @bar_bar = "Version: #{version_info} Length: #{length_info} Data: "
  end

  def calculate_version_info
    fib_instance = NaiveFibonacci.new
    fib_instance.fib(@foo_data["version"])
  end

  def calculate_length_info
    sum = 0
    @foo_data["interesting_data"].each_char { |char| sum += char.ord }
    sum
  end
end

# Grug see who faster, smart or fresh
def benchmark_transformations
  foo_example = {"version" => 20, "interesting_data" => "Hello, world! " * 100}
  hostnames = ["example.com", "localhost", "test.com", "example.org"]

  Benchmark.ips do |x|
    x.report("memoized protocol") do
      transformer = MemoizedProtocolTransformer.new(foo_example)
      transformer.transform
    end

    x.report("naive protocol") do
      transformer = NaiveProtocolTransformer.new(foo_example)
      transformer.transform
    end
    x.compare!
  end

  Benchmark.ips do |x|
    x.report("concurrent DNS lookup batch") do
      dns_lookup = ConcurrentDNSLookup.new
      dns_lookup.resolve(hostnames)
    end

    x.report("naive DNS lookup batch") do
      dns_lookup = NaiveDNSLookup.new
      dns_lookup.resolve(hostnames)
    end

    x.compare!
  end
end

benchmark_transformations
