#set title "Signal diagnostics"
set xlabel "Time (s)"
set ylabel "Amplitude"
set grid
set key outside

# Set the output terminal
#set terminal png size 800,600
set term pngcairo size 2000,600
set output "wave_plot.png"
#set logscale x 2

plot "wave.dat" using 1:2 with lines title "A", \
#     "wave.dat" using 1:3 with lines title "B", \