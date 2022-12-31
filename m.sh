status=1
fileName=dataset.txt
tempFile=datasetTEMP.txt
if [ $status -ne 0 ] # to check if the file readed


then  


    cp $fileName $tempFile # making temporary dataset file to work on
    
    
    


    read -p " Please input the name of the feature to be scaled :  "  feature # read the feature name from user
    fieldNum=$( awk -v b="$feature" -F ";" 'NR==1 {for(i=1;i<=NF;i++){if($i ~ b ){print i}}}'  $tempFile ) #saves field num, if the feature name is not found it will be empty
    if [ -z "$fieldNum" ] # to check if we found the feature or not
    then # the feature doesn't exists
        
        echo "The name of categorical feature is wrong :("  
        
	
        
    else # found it maybe
        
        value=$(awk -F ";"  -v F=$fieldNum ' NR==2 {print $F }' $tempFile ) # gets the value of feature data to check if it is an integer or not
        ## here must change to datasetTemp.txt
        echo "------funm---$fieldNum"
        
        if [[ $value =~ ^[0-9]+$ ]]; then # '^' first character, '$' last character, '+' one or more times
            echo "Value is an integer"

            
            
            awk  -v col="$fieldNum"  -F ";" 'NR>=2 {print $col }' $tempFile >> temp.txt  
            sort -n temp.txt > temp2.txt # sort the data in temp file and add it to temp2 file

            rm temp.txt # remove temp file Useless
            
            
            min=$(head -n 1 temp2.txt) # get the min value
            max=$(tail -n 1 temp2.txt) # get the max value

            rm temp2.txt # remove temp2 file Useless

            echo "min is $min" 
            echo "max is $max"

            
            numlines=$(wc -l $fileName | awk -F " " '{ print $1 }') # get the number of lines in dataset
            touch temp.txt # create temp file

            awk 'NR==1 {print }' $tempFile > temp.txt # add the first line to temp file
	    numlines=$(expr $numlines + 1) # get the number of lines in dataset
            for ((i=2; i <= $numlines ; i++)) # loop in dataset to change the values
            do
                fieldVal=$(awk -F ";"  -v F=$fieldNum -v L=$i ' NR==L {print $F }' $tempFile ) # get the value of feature in line i
               

                a=$(expr $fieldVal - $min) # get the value - min
                b=$(expr $max - $min) # get the max - min
                newVal=$(echo "scale=3; $a / $b" | bc) # scale=3 means 3 decimal places after the decimal point 
                #bc is the command to calculate
               newVal=$(printf "%.2f\n" $newVal) # print the result with 2 decimal places

                awk -v F=$fieldNum -v L=$i -v V=$newVal -F ";" 'NR==L {$F=V}1' $tempFile > temp2.txt # change the value of feature in line i to the new value
                cp temp2.txt $tempFile # copy the temp2 file to dataset file
                sed -i '' 's/ /;/g' $tempFile # replace " " with ; in dataset file to make it as input file ,, the '' cause im using mac
 

                

            
		
            done

            rm temp.txt # remove temp file Useless
            rm temp2.txt # remove temp2 file Useless
         

    
		    
        else
            echo this feature is categorical feature and must be encoded first
	    sleep 1
	    echo Back to main menu ... 
	    sleep 1


        fi

    fi
else
    
    echo Please read the file first
    sleep 1
    echo Back to main menu ... 
    sleep 1
    

fi 