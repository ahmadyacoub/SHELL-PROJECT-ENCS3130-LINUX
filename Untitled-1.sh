
                    # #     dataFields=$( awk -F ";" 'NR ==1 {print NF }' dataset.txt)  # get num of data fields
                        
                    # #    # for(i=1;i<=$dataFields;i++) do
                    # #    # {if ($i ~ /age/) then
                        
                    # #    # {print $i}
                    # #    # }
                    # #    # fi
                    # #     #done

                    # #    # if [ "a2ge" == "$( awk -F ";" ' NR==1 {for(i=1;i<=NF;i++){if($i ~ /age/){print $i}}}'  dataset.txt)" ]
                    # #     then
                    # #     # echo "yaaaaaay "

                    # #      #fi
                    # #     a=age
                        
                    # #   #  fieldNum=$( awk -v b="$a" -F ";" ' NR==1 {for(i=1;i<=NF;i++){if($i ~ b){print i}}}'  dataset.txt) #saves field num 

                    # #        if [ "$feature" == "$( awk -v a="$feature" -F ";" ' NR==1 {for(i=1;i<=NF;i++){if($i ~ /a/){print $i}}}'  dataset.txt)" ]
                    # #       then
                    # #        echo "yaaaaaay "
                    # #         else 
                    # #            echo
                    # #              echo data field not exists
                    # #               echo

                    # #               fi

                


                     read -p "  Please input the name of the categorical feature for label encoding :  "  feature
                    lineNum=$( grep -n -w  "$feature" newdata.txt | awk -F ":" '{print $1}') #saves field num 
                    echo ---------
                    echo " field number -> $lineNum"
                    echo --------
                    if [ -z "$lineNum" ] # to check if we found the feature or not
                         then
                         
                          echo "The name of feature is not added yet :("  

                          echo $feature >> newdata.txt

                          lineNum=$( grep -n -w  "$feature" newdata.txt | awk -F ":" '{print $1}') #saves field num 
                          
                              echo ---------
                              echo " field number -> $lineNum"
                              echo --------

                         else
                              echo "Maybe we found it let me check :) "
                              sleep 1
                              featureName=$(awk -v f=$lineNum -F ";" ' NR==1 {print $f}'  newdata.txt)
                   
                              echo " feature name -----> $featureName"


                               if [ "$feature" == "$featureName" ] # to check if the field have same feature name

                                  then    
                                         echo "they are the sammme :)"
                              else
                                        echo "they are not the sammme :)"

                                 fi
                              
                            
                    fi



# #awk -v n="3" -F ";" '{ print $n }' dataset.txt > featureValues.txt
# numOfLinesInDataSet=$(wc -l dataset.txt| awk -F " " '{ print $1 }')
# echo $numOfLinesInDataSet

# for ((i =2 ; i <= $numOfLinesInDataSet ; i++))
# do 
#         fTemp=$(awk  -F ";" ' { print $1 }' dataset.txt)
#                     lineNum=$( grep -n -w  "$feature" newdata.txt | awk -F ":" '{print $1}') #saves field num 
#                     echo ---------
#                     echo " field number -> $lineNum"
#                     echo --------
#                     if [ -z "$lineNum" ] # to check if we found the feature or not
#                          then
                         
#                           echo "The name of feature is not added yet :("  

#                           echo $feature >> newdata.txt

#                           lineNum=$( grep -n -w  "$feature" newdata.txt | awk -F ":" '{print $1}') #saves field num 
                          
#                               echo ---------
#                               lineNum=$( grep -n -w  "$feature" newdata.txt | awk -F ":" '{print $1}')
#                               echo " field number -> $lineNum"
#                               echo --------

#                          else
#                               echo "Maybe we found it let me check :) "
#                               sleep 1
#                               featureName=$(awk -v f=$lineNum -F ";" ' NR==1 {print $f}'  newdata.txt)
                   
#                               echo " feature name -----> $featureName"


#                                if [ "$feature" == "$featureName" ] # to check if the field have same feature name

#                                   then    
#                                          echo "they are the sammme :)"
#                               else
#                                         echo "they are not the sammme :)"

#                                  fi
                              
                            
#                     fi




# done
       
              

                  
       
                
               
      
        

                    



                        