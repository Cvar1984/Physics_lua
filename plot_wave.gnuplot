set title "Original vs reformed"
set xlabel "Time (t)"
set ylabel "Amplitude"
set grid
set key outside

# Set the output terminal
#set terminal png size 800,600
set term pngcairo size 2000,600
set output "wave_plot.png"

plot "wave.dat" using 1:2 with lines title "Original Wave", \
     "wave.dat" using 1:3 with lines title "Reformed Wave", \

