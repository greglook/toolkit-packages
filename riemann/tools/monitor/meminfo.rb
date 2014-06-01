# Read memory usage.
read "/proc/meminfo" do
  match /^MemTotal:\s+(\d+) kB$/,  record: "memory total bytes",   cast: :to_i, scale: 1024
  match /^MemFree:\s+(\d+) kB$/,   record: "memory free bytes",    cast: :to_i, scale: 1024
  match /^Buffers:\s+(\d+) kB$/,   record: "memory buffers bytes", cast: :to_i, scale: 1024
  match /^Cached:\s+(\d+) kB$/,    record: "memory cached bytes",  cast: :to_i, scale: 1024
  match /^Active:\s+(\d+) kB$/,    record: "memory active bytes",  cast: :to_i, scale: 1024
  match /^SwapTotal:\s+(\d+) kB$/, record: "swap total bytes",     cast: :to_i, scale: 1024
  match /^SwapFree:\s+(\d+) kB$/,  record: "swap free bytes",      cast: :to_i, scale: 1024
end

# Calculate percentages from total space.
compute do |metrics|
  [%w{memory  free buffers cached active},
   %w{swap    free}].each do |info|
    sys = info.shift
    total = metrics["#{sys} total bytes"]
    if total && total > 0
      info.each do |stat|
        bytes = metrics["#{sys} #{stat} bytes"]
        if bytes
          pct = bytes.to_f/total
          metrics["#{sys} #{stat} pct"] = pct
        end
      end
    end
  end
  metrics
end

service "swap free pct", state: thresholds(0.00, "critical", 0.10, "warning", 0.25, "ok")
