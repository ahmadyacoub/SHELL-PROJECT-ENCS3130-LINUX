result=$(echo "scale=3; 9 / 23" | bc) # scale=3 means 3 decimal places after the decimal point 
#bc is the command to calculate
printf "%.2f\n" $result # print the result with 2 decimal places
