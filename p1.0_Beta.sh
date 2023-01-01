
status=0
tempFile=datasetTEMP.txt

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
	    
            read -p "Please input the name of the dataset file :  "  fileName # read the file name from user
			fileName=$fileName.txt
            
            
            if [ -e $fileName ] # checks  if file exists
            then
		
		fs1=$( awk -F ";" 'NR ==1 {print NF }' $fileName )  # get num of data fields
		fs2=$( awk -F ";" 'NR ==2 {print NF }' $fileName )  # get num of data fields

		if [ $fs1 -eq $fs2 ] # to check if the file is clean or not
		then
		    echo "file is clean"
		    cp $fileName $tempFile # making temporary dataset file to work on
		    status=1
		else
		    echo "file is not clean"
		fi
	
            else

			echo
			echo

			echo "file does not exist :( "

			echo
			echo
            fi
    	    echo Back to main menu ...
			echo
			echo
	    sleep 2
            ;;
        
        p)
            if [ $status -ne 0 ] # to  check if the file readed

            then    
		echo 
		echo "------------------------------ FILE DATA ------------------------------"
		echo
		awk -F ";" '{$1=""; print $0}' $tempFile # print the data in the file
		echo
		echo "-------------------------------- DONE ---------------------------------"
		#awk -F ";" '{ for (i=1; i<=NF; i++) print $i }' $fileName.txt
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
		fieldNum=$( awk -v b="$feature" -F ";" 'NR==1 {for(i=1;i<=NF;i++){if($i ~ b ){print i}}}'  $fileName) #saves field num 
		
		if [ -z "$fieldNum" ] # to check if we found the feature or not
		then # the feature doesn't exists
                    
                    echo "The name of categorical feature is wrong :("  
                    
		    
                    
		else # found it maybe 
                    # echo "Maybe we found it let me check :) "
                    # sleep 1
                    featureName=$(awk -v f=$fieldNum -F ";" ' NR==1 {print $f}'  $fileName ) # saves feature name from dataset 
                    
                    # echo " feature name -----> $featureName"


                    if [ "$feature" == "$featureName" ] # to check if the field have same feature name

                    then    # its the same

			# echo "they are the sammme :)"
			(awk -v f=$fieldNum -F ";" ' NR>1 {print $f}'  $fileName > featureValuesTemp.txt ) 
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

                        cp $fileName $tempFile # making temporary dataset file to work on

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


                        numOfEncodedStrings=$(wc -l $fileName | awk -F " " '{print $1}')
                        numOfEncodedStrings+=1 # to replace the last line
                        nf=$fieldNum ## must get it //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                        
                        touch temp.txt

                        awk  -F " " ' NR == 1 {print $1 }' $fileName > temp.txt  # to add the header to the temp file
                        for ((i=2; i <= $numOfEncodedStrings ; i++))
                        do
                            tmp=$(awk -v I=$i -v field=$nf -F ";" ' NR==I {print $field }' $fileName ) # gets data from the specific column and row
                            if [ -z "$tmp" ] 
                            then 
				break
                            else
				value=$(grep -n -w "$tmp" featureValues.txt | awk -F ":" '{print $1}') # get its value from the unique file
				
				awk  -v col="$nf" -v val="$value" -v lNum="$i" -F ";" ' NR == lNum {$col=val; print}' $tempFile >> temp.txt 
				# change specific column inspecific line and print it in temp file
				sed -i '' 's/ /;/g' temp.txt # to get back the semicolun


				#    sed -i '' ''"$i"'s/'"$tmp;"'/'"$value;"'/' datasetTEMP.txt # the '' cause im using mac why ? OS X requires the extension to be explicitly specified.


                            fi 
                            
                        done

                        ## removes unneded files
                        rm featureValuesTemp.txt
                        rm featureValues.txt
                        cp temp.txt $tempFile
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
            if [ $status -ne 0 ]
	       #TO DO  THIS FOR ONE HOT
	       #1 - READ FROM FILE DATASET 
	       #2 - REGEX ? AND IF THERE 1 ELSE 0  
	       #CONCNATE THE STRING AND SAVE

	    then  

		read -p "  Please input the name of the categorical feature for label encoding :  "  feature # read the feature name from user
		fieldNum=$( awk -v b="$feature" -F ";" ' NR==1 {for(i=1;i<=NF;i++){if($i ~ b){print i}}}'  $fileName ) #saves field num 
		
		if [ -z "$fieldNum" ] # to check if we found the feature or not
		then # the feature doesn't exists
		    
		    echo "The name of categorical feature is wrong :("  
		    
		    
		    
		else # found it maybe 
		    # echo "Maybe we found it let me check :) "
		    # sleep 1
		    featureName=$(awk -v f=$fieldNum -F ";" ' NR==1 {print $f}'  $fileName ) # saves feature name from dataset 
		    
		    

		    if [ "$feature" == "$featureName" ] # to check if the field have same feature name

		    then    # its the same

			# echo "they are the sammme :)"
			(awk -v f=$fieldNum -F ";" ' NR>1 {print $f}'  $fileName > featureValuesTemp.txt ) 
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

			cp $fileName $tempFile # making temporary dataset file to work on

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

			

			sed -i '' '1s/'"$feature;"'/'"$newString"'/' $tempFile # the '' cause im using mac why ? OS X requires the extension to be explicitly specified.
			# the $i refers to line number and the $tmp refers to the data that we want to replace it with $value

			numOflinesInDataset=$(wc -l $fileName | awk -F " " '{print $1}') # gets num of lines in dataset

			numOflinesInDataset_plusOne=$numOflinesInDataset
			
			
			numOflinesInDataset_plusOne=$(expr $numOflinesInDataset_plusOne + 1) # to use last line 


			
			
			for ((i=2; i <= $numOflinesInDataset_plusOne ; i++)) # started from i = 2 cause data starts from line 2 (line 1 is header)
			do
			    newString=""
			    tmp2=""
			    for ((j=2; j <= $numOflinesInFeatureValues ; j++)) # started from i = 2 cause data starts from line 2
			    do
				tmp=$(awk -v I=$j ' NR==I {print $1 }' featureValues.txt )
				value=$(awk -F ";" -v I=$i -v F=$fieldNum ' NR==I {print $F }' $fileName )
				
				if [ "$tmp" == "$value" ] # to check if the data is the same as the feature value
				then
				    newString+="1;"
				    tmp2=$tmp
				else
				    newString+="0;"

				fi
			    done
			    sed -i '' ''"$i"'s/'"$tmp2;"'/'"$newString"'/' $tempFile
			    


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
            ;;
        m) 
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
