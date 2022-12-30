if [ $status -ne 0 ] # to check if the file readed
then   
    # in awk -v --> letting me to use variables in awk cuz of  ' $var'
    rm featureValues.txt 


    
    

    read -p "  Please input the name of the categorical feature for label encoding :  "  feature # read the feature name from user
    fieldNum=$( awk -v b="$feature" -F ";" ' NR==1 {for(i=1;i<=NF;i++){if($i ~ b){print i}}}'  dataset.txt) #saves field num 
    # echo ---------
    # echo " field number -> $fieldNum"
    # echo --------
    if [ -z "$fieldNum" ] # to check if we found the feature or not
    then # the feature doesn't exists
        
        echo "The name of categorical feature is wrong :("  
        
        
    else # found it 
        echo "Maybe we found it let me check :) "
        sleep 1
        featureName=$(awk -v f=$fieldNum -F ";" ' NR==1 {print $f}'  dataset.txt) # saves feature name from dataset 
        
        # echo " feature name -----> $featureName"


        if [ "$feature" == "$featureName" ] # to check if the field have same feature name

        then    # its the same

            echo "they are the sammme :)"
            (awk -v f=$fieldNum -F ";" ' NR>1 {print $f}'  dataset.txt > featureValuesTemp.txt ) 
            # getting all feature imputs and add them to temp file ^^^

            numOfEncodedStrings=$(wc -l featureValuesTemp.txt | awk -F " " '{ print $1 }')
            # getting num of lines ^^^
            

            # the for down here for what?
            for ((i=0; i <= $numOfEncodedStrings ; i++)) ## loop in temp file to check every data and add it to unique file 
            do 
                featureTemp=$(awk -v I=$i -F " " 'NR == I { print $1 }' featureValuesTemp.txt) # first column data saves
                
                lineNum=$( grep -n -w  "$featureTemp" featureValues.txt | awk -F ":" '{print $1}') #saves line num 
                
                if [ -z "$lineNum" ] # to check if we found the feature Value or not from unique file
                then
                    echo "The name of feature is not added yet :("  
                    echo $featureTemp >> featureValues.txt
                    lineNum=$( grep -n -w  "$featureTemp" featureValues.txt | awk -F ":" '{print $1}') #saves field num 
                    
                else
                    echo "Maybe we found it let me check :) "
                    sleep 1

                    featureName=$(awk -v f=$lineNum -F " " ' NR==f {print $1}'  featureValues.txt)
                    
                    
                    # if [ "$featureTemp" == "$featureName" ] # to check if the field have same feature name

                    #           then    
                    #      echo "they are the sammme :)"
                    # else
                    #      echo "they are not the sammme :)"

                    # fi

                    # the for ^^^^^ here for what?


                    for ((i=2; i <= $numOfEncodedStrings ; i++)) ## loop in temp file to check every data and make label string for header
                    do 
                        featureTemp="$(awk -v I=$i -F " " 'NR == I { print $1 }' featureValues.txt)" # first column data saves
                        
                        if [ -z $featureTemp ] 
                        then 
                            echo empty
                            
                        else
                            featureTemp+=';'
                            string+=$featureTemp
                            
                        fi
                        
                        

                    done
                    echo " h3####@#@#@@@#######################################################"
                    echo $string
                    
                    cp dataset.txt datasetTEMP.txt

                    sed -i '' 's/'"$feature;"'/'"$string"'/' datasetTEMP.txt # the '' cause im using mac why ? OS X requires the extension to be explicitly specified.
                    
                    #sed -i to only change the data without showing it in terminal
                    
                    
                    # --------------------   till here the code adds in feature its values in tempDataSet file --------------------------


                    tempTwo=" " #new empty for all data change
                    for ((i=2; i <= $numOfEncodedStrings ; i++)) ## loop in temp file to check every data and make label string for all data change
                    do 
                        labelString=" " # concnates the 1;0;1
                        labelTemp=$(awk -v v=$i -v field=$fieldNum -F ";" 'NR == v {print $field}' dataset.txt) # gets the dataset feature value one by one fro dataset
                        echo ----ltest
                        awk -v v=$i -v field=$fieldNum -F " " 'NR == v {print $1}' dataset.txt
                        echo $numOfEncodedStrings
                        echo ----ltest

                        for ((i=2; i <= $numOfEncodedStrings ; i++)) ## loop in temp file to check every data and make label string for header
                        do 
                            featureTemp="$(awk -v I=$i -F " " 'NR == I { print $1 }' featureValues.txt)" # first column data saves
                            
                            if [ -z $featureTemp ] 
                            then 
                                echo empty
                                
                            else
                                if [ "$featureTemp" == "$labelTemp" ]
                                then
                                    labelString+=';1'
                                else
                                    labelString+=';0'
                                fi


                                
                                echo ----2222222222222
                                echo --------- $labelString
                                echo ----2222222222222
                                
                            fi
                            
                            

                        done

                        

                        #fieldNum

                        
                        # ECHO THE DATA OF FEATUREVALUE AND EACH LINE NUM 
                        #GREP OR AWK | AWK | TO GET THE F1 == LINE NUM 
                        #SED
                        
                        
                        if [ -z $featureTemp] 
                        then 
                            echo empty
                            
                        else
                            featureTemp+=';'
                            string+=$featureTemp
                            
                        fi
                        
                        

                    done     
                    
                    #--------------
                fi

                







                echo ---------------------------------------------------------------------

            done


        else
            echo "they are not the sammme :)"

        fi
        
        
    fi

    
    echo "BACK TO MAIN MENU . . . ."
    sleep 1 
    
else
    echo Please read the file first
    sleep 1
    echo Back to main menu ... 
    sleep 1
    clear 

fi