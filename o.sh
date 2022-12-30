status=1
if [ $status -ne 0 ]
   #TO DO  THIS FOR ONE HOT
   #1 - READ FROM FILE DATASET 
   #2 - REGEX ? AND IF THERE 1 ELSE 0  
   #CONCNATE THE STRING AND SAVE

then  

    read -p "  Please input the name of the categorical feature for label encoding :  "  feature # read the feature name from user
    fieldNum=$( awk -v b="$feature" -F ";" ' NR==1 {for(i=1;i<=NF;i++){if($i ~ b){print i}}}'  dataset.txt) #saves field num 
    
    if [ -z "$fieldNum" ] # to check if we found the feature or not
    then # the feature doesn't exists
        
        echo "The name of categorical feature is wrong :("  
        
        
        
    else # found it maybe 
        # echo "Maybe we found it let me check :) "
        # sleep 1
        featureName=$(awk -v f=$fieldNum -F ";" ' NR==1 {print $f}'  dataset.txt) # saves feature name from dataset 
        
        

        if [ "$feature" == "$featureName" ] # to check if the field have same feature name

        then    # its the same

            # echo "they are the sammme :)"
            (awk -v f=$fieldNum -F ";" ' NR>1 {print $f}'  dataset.txt > featureValuesTemp.txt ) 
            # getting all feature inputs and add them to temp file ^^^

            numOfEncodedStrings=$(wc -l featureValuesTemp.txt | awk -F " " '{ print $1 }')
            # getting num of lines from  featureValuesTemp.txt file ^^^
            
            touch featureValues.txt # creating unique file to save feature inputs
            
            for ((i=0; i <= $numOfEncodedStrings ; i++)) ## loop in temp file to check every data and add it to unique file 
            do 
                featureTemp=$(awk -v I=$i -F " " 'NR == I { print $1 }' featureValuesTemp.txt) # first row data saves
                
                
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

            numOflinesInFeatureValues=$(wc -l featureValues.txt | awk -F " " '{print $1}') # gets num of lines in featureValues.txt
            newString=""
            
            for ((i=2; i <= $numOflinesInFeatureValues ; i++)) # started from i = 2 cause data starts from line 2
            do
                tmp=$(awk -v I=$i ' NR==I {print $1 }' featureValues.txt )
		
                
                
                if [ -z "$tmp" ] # cause i used num of Encoded strings that have much data than featureValues.txt
                then 
                    break
                else
                    newString+="$tmp;"

                fi 


            done
            
            echo ---------------------

            echo   $newString

            echo ---------------------

            

            sed -i '' '1s/'"$feature;"'/'"$newString"'/' datasetTEMP.txt # the '' cause im using mac why ? OS X requires the extension to be explicitly specified.
            # the $i refers to line number and the $tmp refers to the data that we want to replace it with $value

            numOflinesInDataset=$(wc -l dataset.txt | awk -F " " '{print $1}') # gets num of lines in dataset.txt

            numOflinesInDataset_plusOne=$numOflinesInDataset
            
            
            numOflinesInDataset_plusOne=$(expr $numOflinesInDataset_plusOne + 1) # to use last line 


            
            
            for ((i=2; i <= $numOflinesInDataset_plusOne ; i++)) # started from i = 2 cause data starts from line 2 (line 1 is header)
            do
		newString=""
		tmp2=""
                for ((j=2; j <= $numOflinesInFeatureValues ; j++)) # started from i = 2 cause data starts from line 2
                do
                    tmp=$(awk -v I=$j ' NR==I {print $1 }' featureValues.txt )
                    value=$(awk -F ";" -v I=$i -v F=$fieldNum ' NR==I {print $F }' dataset.txt )
                    
                    if [ "$tmp" == "$value" ] # to check if the data is the same as the feature value
                    then
                        newString+="1;"
                        tmp2=$tmp
                    else
                        newString+="0;"

                    fi
                done
		sed -i '' ''"$i"'s/'"$tmp2;"'/'"$newString"'/' datasetTEMP.txt
                


            done
            

            cat featureValues.txt

            rm featureValuesTemp.txt
            rm featureValues.txt

	    

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
    

fi