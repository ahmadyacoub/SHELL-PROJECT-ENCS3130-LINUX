##------ this for loop replaces the feature with its data----------

 numOfEncodedStrings=$(wc -l featureValues.txt | awk -F " " '{ print $1 }')

   # getting num of lines ^^^


                                 for ((i=2; i <= $numOfEncodedStrings ; i++)) ## loop in temp file to check every data and make label string for header
                                    do 
                                             featureTemp="$(awk -v I=$i -F " " 'NR == I { print $1 }' featureValues.txt);" # first column data saves
                                             
                                                echo $featureTemp
                                                string+=$featureTemp

                                    done

                                             echo $string

                                             sed -i '' 's/governorate;/'"$string"'/' datasetTEMP.txt # the '' cause im using mac why ? OS X requires the extension to be explicitly specified.
                                            
                                             #sed -i to only change the data without showing it in terminal
                                             #-----

                                             echo
                                             echo
                                             echo -------


                                 for ((i=2; i <= $numOfEncodedStrings ; i++)) ## loop in temp file to check every data and add it to unique file 
                                    do 
                                             featureTemp="$(awk -v I=$i -F " " 'NR == I { print $1 }' featureValues.txt);" # first column data saves
                                             
                                               awk -v line=$i -v b="$feature" -F ";" ' NR==line {for(i=1;i<=NF;i++){if($i ~ b){print i}}}'  dataset.txt
                                             
                                                

                                    done
                                          



                                             echo
                                             echo
                                             echo -------
                                             
                                             #-----
                                             

                                


#--------------