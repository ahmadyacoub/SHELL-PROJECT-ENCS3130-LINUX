status=1 
if [ $status -ne 0 ] # to check if the file readed
then   
    # in awk -v --> letting me to use variables in awk cuz of  ' $var'
    
    

    read -p "  Please input the name of the categorical feature for label encoding :  "  feature # read the feature name from user
    fieldNum=$( awk -v b="$feature" -F ";" ' NR==1 {for(i=1;i<=NF;i++){if($i ~ b){print i}}}'  dataset.txt) #saves field num 
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
            numOfEncodedStrings=$(wc -l dataset.txt | awk -F " " '{print $1}')
            numOfEncodedStrings+=1 # to replace the last line
            nf=3 ## must get it //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

            for ((i=2; i <= $numOfEncodedStrings ; i++))
            do
                tmp=$(awk -v I=$i -v field=$nf -F ";" ' NR==I {print $field }' dataset.txt )
                if [ -z "$tmp" ]
                then 
                    break
                else
                    value=$(grep -n -w "$tmp" featureValues.txt | awk -F ":" '{print $1}')
                    echo "tmp = $tmp val = $value "
                    
                    sed -i '' ''"$i"'s/'"$tmp;"'/'"$value;"'/' datasetTEMP.txt # the '' cause im using mac why ? OS X requires the extension to be explicitly specified.


                fi 
                
            done

            cat featureValues.txt

            rm featureValuesTemp.txt
            rm featureValues.txt

            

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
