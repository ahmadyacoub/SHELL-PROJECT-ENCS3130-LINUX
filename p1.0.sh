
     status=0

     while true 


     do 
          
          echo "select one from the list"
     echo "r)    Read a dataset from a file "
     echo "p)    print the names of the features "   
     echo "l)    encode feature using label encoding "
     echo "o)    encode feature using one-hot encoding "
     echo "m)    apply MinMax scalling"
     echo "s)    save the processed dataset "   
     echo "e)    Exit "  

     read -p " --------------------> :  "  choice

          case "$choice" in 
               r) 
     
          read -p "Please input the name of the dataset file :  "  user_var
          echo $user_var
          
          if [ -e $user_var.txt ] # checks  if file exists
               then
          
               echo "ok"
               status=1
          else
               echo "file does not exist :( "
          fi
          dataFields=$( awk -F ";" 'NR ==1 {print NF }' $user_var.txt)  # get num of data fields
          echo $dataFields
     
     
               

     sleep 1
                    ;;
               
               p)
          if [ $status -ne 0 ] # to  check if the file readed

               then    
               echo 
               echo "------------------------------ FILE DATA ------------------------------"
               echo
               awk -F ";" '{$1=""; print $0}' $user_var.txt
               echo
               echo "-------------------------------- DONE ---------------------------------"
               #awk -F ";" '{ for (i=1; i<=NF; i++) print $i }' $user_var.txt
          else
               echo Please read the file first
               sleep 1
               echo Back to main menu ... 
               sleep 1
               clear 

          fi
               ;;
          
          l) 
        
if [ $status -ne 0 ] # to check if the file readed
then   
            # in awk -v --> letting me to use variables in awk cuz of  ' $var'
            
          

            read -p "  Please input the name of the categorical feature for label encoding :  "  feature # read the feature name from user
            fieldNum=$( awk -v b="$feature" -F ";" 'NR==1 {for(i=1;i<=NF;i++){if($i ~ b){print i}}}'  dataset.txt) #saves field num 
            # echo ---------
            # echo " field number -> $fieldNum"
            # echo --------
        if [ -z "$fieldNum" ] # to check if we found the feature or not
            then # the feature doesn't exists
                
                echo "The name of categorical feature is wrong :("  
                
              
                
            else # found it maybe 
                # echo "Maybe we found it let me check :) "
                # sleep 1
                featureName=$(awk -v f=$fieldNum -F ";" ' NR==1 {print $f}'  dataset.txt) # saves feature name from dataset 
                
                # echo " feature name -----> $featureName"


                      if [ "$feature" == "$featureName" ] # to check if the field have same feature name

                        then    # its the same

                    # echo "they are the sammme :)"
                    (awk -v f=$fieldNum -F ";" ' NR>1 {print $f}'  dataset.txt > featureValuesTemp.txt ) 
                    # getting all feature inputs and add them to temp file ^^^

                    numOfEncodedStrings=$(wc -l featureValuesTemp.txt | awk -F " " '{ print $1 }')
                    # getting num of lines from  featureValuesTemp.txt file ^^^
                    
                         for ((i=0; i <= $numOfEncodedStrings ; i++)) ## loop in temp file to check every data and add it to unique file 
                         do 
                        featureTemp=$(awk -v I=$i -F " " 'NR == I { print $1 }' featureValuesTemp.txt) # first column data saves
                        
                        touch featureValues.txt
                        lineNum=$( grep -n -w  "$featureTemp" featureValues.txt | awk -F ":" '{print $1}') #saves line num 

                            # echo  "f name  $featureTemp on line -> $lineNum" 
                        
                            if [ -z "$lineNum" ] # to check if we found the feature Value or not from unique file
                        
                             then # when we cannot find the line num of it then the data is  not added !! 
                            # echo "The name of feature is not added yet :("   
                            echo $featureTemp >> featureValues.txt #    then we will add it 
                            lineNum=$( grep -n -w  "$featureTemp" featureValues.txt | awk -F ":" '{print $1}') #saves field num 
                            
                            else 
                           

                            featureName=$(awk -v f=$lineNum -F " " ' NR==f {print $1}'  featureValues.txt) # gets data from fefeatureValues.txt (that conatins feature inputs)

                            # echo " - > feature name $featureName"
                            
                           
                             fi

                        
                         done

                         cp dataset.txt datasetTEMP.txt # making temporary dataset file to work on

                        echo -------------------------------
                        for ((i=2; i <= $numOfEncodedStrings ; i++))
                        do
                            tmp=$(awk -v I=$i ' NR==I {print $1 }' featureValues.txt )
                            
                            if [ -z "$tmp" ]
                            then 
                               break
                            else
                            echo "feature $tmp  Value is : $i"

                            fi 


                        done
                                               
                         echo -------------------------------


                        numOfEncodedStrings=$(wc -l dataset.txt | awk -F " " '{print $1}')
                        numOfEncodedStrings+=1 # to replace the last line
                        nf=$fieldNum ## must get it //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                         
                         touch temp.txt

                         awk  -F " " ' NR == 1 {print $1 }' dataset.txt > temp.txt  # to add the header to the temp file
                        for ((i=2; i <= $numOfEncodedStrings ; i++))
                        do
                            tmp=$(awk -v I=$i -v field=$nf -F ";" ' NR==I {print $field }' dataset.txt ) # gets data from the specific column and row
                            if [ -z "$tmp" ] 
                            then 
                               break
                            else
                          value=$(grep -n -w "$tmp" featureValues.txt | awk -F ":" '{print $1}') # get its value from the unique file
                         
                            awk  -v col="$nf" -v val="$value" -v asd="$i" -F ";" ' NR == asd {$col=val; print}' datasetTEMP.txt >> temp.txt 
                            # change specific column inspecific line and print it in temp file
                            sed -i '' 's/ /;/g' temp.txt # to get back the semicolun


                         #    sed -i '' ''"$i"'s/'"$tmp;"'/'"$value;"'/' datasetTEMP.txt # the '' cause im using mac why ? OS X requires the extension to be explicitly specified.


                            fi 
                            
                        done

                         ## removes unneded files
                         rm featureValuesTemp.txt
                         rm featureValues.txt
                         cp temp.txt datasetTemp.txt
                         rm temp.txt

                    

                    #fieldNum

                    
                    # ECHO THE DATA OF FEATUREVALUE AND EACH LINE NUM 
                    #GREP OR AWK | AWK | TO GET THE F1 == LINE NUM 
                    #SED
                    
            
                    
                    

    

                 else
            # echo "they are not the sammme :)"
            echo "BACK TO MAIN MENU . . . ."
            sleep 1 
                 fi
        fi
 else
            echo Please read the file first
            sleep 1
            echo Back to main menu ... 
            sleep 1
            clear 

fi

          ;;
          o) 

           #TO DO  THIS FOR ONE HOT
                                                                      #1 - READ FROM FILE DATASET 
                                                                      #2 - REGEX ? AND IF THERE 1 ELSE 0  
                                                                      #CONCNATE THE STRING AND SAVE



                    #  for ((i=2; i <= $numOfEncodedStrings ; i++)) ## loop in temp file to check every data and make label string for header
                    # do 
                    #     featureTemp="$(awk -v I=$i -F " " 'NR == I { print $1 }' featureValues.txt)" # first column data saves
                        
                    #     if [ -z $featureTemp ] 
                    #     then 
                    #         echo empty
                            
                    #     else
                    #         featureTemp+=';'
                    #         string+=$featureTemp
                            
                    #     fi
                    #done
                #    sed -i '' 's/'"$feature;"'/'"$string"'/' datasetTEMP.txt # the '' cause im using mac -> WHY? -> OS X requires the extension to be explicitly specified
               if [ $status -ne 0 ] # to check if the file readed

               then    
                    echo p 
          else
               echo Please read the file first
               sleep 1
               echo Back to main menu ... 
               sleep 1
               clear 

          fi
          ;;
          m) 
               if [ $status -ne 0 ] # to check if the file readed

               then    
                    echo p 
          else
               echo Please read the file first
               sleep 1
               echo Back to main menu ... 
               sleep 1
               clear 

          fi
          ;;
          s) 
               if [ $status -ne 0 ] # to check if the file readed

               then    
                    echo p 
          else
               echo Please read the file first
               sleep 1
               echo Back to main menu ... 
               sleep 1
               clear 

          fi
          ;;
          e) 
          echo Exiting ... 
          sleep 1
          exit 1
          ;;
          *)
          clear 
               echo " thats not an option"
               sleep 2
               ;;
          
          esac
               
     done