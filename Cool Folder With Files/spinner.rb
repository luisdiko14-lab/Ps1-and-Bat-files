# spinner.rb

spinner = ['|', '/', '-', '\\']
colors = [
  "\e[31m", # Red
  "\e[33m", # Yellow
  "\e[32m", # Green
  "\e[36m", # Cyan
  "\e[34m", # Blue
  "\e[35m"  # Magenta
]

i = 0

print "\e[?25l" # hide cursor

60.times do
  color = colors[i % colors.length]
  print "\r#{color}Loading #{spinner[i % spinner.length]}\e[0m"
  sleep 0.1
  i += 1
end

print "\r\e[32mDone! ✔\e[0m\n"
print "\e[?25h" # show cursor
