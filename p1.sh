
status=0
dataSaved=0
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
	    
            read -p "Please input the name of the dataset file (do not include .txt) :  "  fileName # read the file name from user
	    fileName=$fileName.txt
            
            
            if [ -e $fileName ] # checks  if file exists
            then
		
		fs1=$( awk -F ";" 'NR ==1 {print NF }' $fileName )  # get num of data fields
		fs2=$( awk -F ";" 'NR ==2 {print NF }' $fileName )  # get num of data fields

		if [ $fs1 -eq $fs2 ] # to check if the file is clean or not
		then
        echo
		    echo "file is read successfully :)"
            echo
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
		echo
            else
		echo "Please read the file first"
		sleep 1
		echo Back to main menu ... 
		sleep 1
		clear 

            fi
            ;;
        
        l) 
            
	    if [ $status -ne 0 ] # to check if the file readed
	    then   
		
		

		read -p "  Please input the name of the categorical feature for label encoding :  "  feature 
		# read the feature name from user - p to read from same line 
		fieldNum=$( awk -v b="$feature" -F ";" 'NR==1 {for(i=1;i<=NF;i++){if($i ~ b ){print i}}}'  $tempFile) #saves field num 
		# in awk -v --> letting me to use variables in awk cuz of  '$var'
		
		if [ -z "$fieldNum" ] # to check if we found the feature or not
		then # the feature doesn't exists

                    echo
                    echo "The name of categorical feature is wrong :("  
                    echo
                    sleep 2
                    echo Back to main menu ...
		else # found it maybe 
                    
		    
                    featureName=$(awk -v f=$fieldNum -F ";" ' NR==1 {print $f}'  $tempFile ) # saves feature name from dataset 
                    

                    if [ "$feature" == "$featureName" ] # to check if the field have same feature name

                    then    # its the same

			# echo "they are the sammme :)"
            
			(awk -v f=$fieldNum -F ";" ' NR>1 {print $f}'  $tempFile > featureValuesTemp.txt ) 
			#NR>1 --> to skip the first line cuz it contains the feature name
			# getting all feature inputs and add them to temp file to work on with 

			numOfEncodedStrings=$(wc -l featureValuesTemp.txt | awk -F " " '{ print $1 }')
			# getting num of lines from  featureValuesTemp.txt file ^^^
			
                        for ((i=0; i <= $numOfEncodedStrings ; i++)) 
                        # loop in temp file to check every feature input and add it to unique file  if not added yet
                        do 
                            featureTemp=$(awk -v I=$i -F " " 'NR == I { print $1 }' featureValuesTemp.txt) # first column data saves
                            # -F necessary
                            touch featureValues.txt    # to create the unique file of feature inputs 
                            lineNum=$( grep -n -w  "$featureTemp" featureValues.txt | awk -F ":" '{print $1}') #saves line num 

                            
                            if [ -z "$lineNum" ] # to check if we found the feature Value or not from unique file
                               
                            then # when we cannot find the line num of it then the data is  not added !! 
				# echo "The name of feature is not added yet :("   
				echo $featureTemp >> featureValues.txt #    then we will add it 
				lineNum=$( grep -n -w  "$featureTemp" featureValues.txt | awk -F ":" '{print $1}') #saves field num 
				
                            else 
				

				featureName=$(awk -v f=$lineNum -F " " ' NR==f {print $1}'  featureValues.txt)
                 # gets data from featureValues.txt (that conatins feature inputs)

				
				
				
                            fi

                            
                        done

                      

                        echo -------------------------------
                        for ((i=2; i <= $numOfEncodedStrings ; i++)) # loop to print the feature inputs and their values
                        do
                            tmp=$(awk -v I=$i ' NR==I {print $1 }' featureValues.txt )
                            
                            if [ -z "$tmp" ]
                            then 
				break
                            else
				echo "feature $tmp Value is : $i"

                            fi 


                        done
                        
                        echo -------------------------------


                        numOfEncodedStrings=$(wc -l $tempFile | awk -F " " '{print $1}')
                        numOfEncodedStrings+=1 # to replace the last line                        
                        touch temp.txt

                        awk  -F " " ' NR == 1 {print $1 }' $tempFile > temp.txt  # to add the header to the temp file
                        for ((i=2; i <= $numOfEncodedStrings ; i++))
                        do
                            tmp=$(awk -v I=$i -v field=$fieldNum -F ";" ' NR==I {print $field }' $tempFile ) 
                            # gets data from the specific column and row
                            if [ -z "$tmp" ] 
                            then 
				break
                            else
				value=$(grep -n -w "$tmp" featureValues.txt | awk -F ":" '{print $1}') # get its value from the unique file
				
				awk  -v col="$fieldNum" -v val="$value" -v lNum="$i" -F ";" ' NR == lNum {$col=val; print}' $tempFile >> temp.txt 
				# change specific column in specific line and print it in temp file
				sed -i '' 's/ /;/g' temp.txt # to get back the semicolun

                            fi 
                            
                        done

                        # remove unneded files
                        rm featureValuesTemp.txt
                        rm featureValues.txt
                        cp temp.txt $tempFile
                        rm temp.txt

			

                    else
			echo
			echo "Something wrong in data feature name :("
			echo
			echo "BACK TO MAIN MENU . . . ."
			
			sleep 1 
                    fi
		fi
	    else
		echo "Please read the file first"
		sleep 1
		echo Back to main menu ... 
		sleep 1
		clear 

	    fi

            ;;
        o)

            if [ $status -ne 0 ] # to check if the file is read or not
               
	       

	    then  

		read -p "  Please input the name of the categorical feature for label encoding :  "  feature # read the feature name from user
		fieldNum=$( awk -v b="$feature" -F ";" ' NR==1 {for(i=1;i<=NF;i++){if($i ~ b){print i}}}'  $tempFile ) #saves field num 
		
		if [ -z "$fieldNum" ] # to check if we found the feature or not
		then # the feature doesn't exists
		    
		    echo
		    echo "The name of categorical feature is wrong :("  
		    echo
		    echo "BACK TO MAIN MENU . . . ."
		    echo
		    sleep 1

		else 

		    featureName=$(awk -v f=$fieldNum -F ";" ' NR==1 {print $f}'  $tempFile ) # saves feature name from dataset 
		    
		    if [ "$feature" == "$featureName" ] # to check if the field have same feature name

		    then    # its the same

			(awk -v f=$fieldNum -F ";" ' NR>1 {print $f}'  $tempFile > featureValuesTemp.txt ) 
			# getting all feature inputs and add them to temp file ^^^

			numOfEncodedStrings=$(wc -l featureValuesTemp.txt | awk -F " " '{ print $1 }')
			# getting num of lines from  featureValuesTemp.txt file ^^^
			
			touch featureValues.txt # creating unique file to save feature inputs
			
			for ((i=0; i <= $numOfEncodedStrings ; i++)) ## loop in temp file to check every data and add it to unique file 
			do 
			    featureTemp=$(awk -v I=$i -F " " 'NR == I { print $1 }' featureValuesTemp.txt) # first row data saves
			    
			    
			    lineNum=$( grep -n -w  "$featureTemp" featureValues.txt | awk -F ":" '{print $1}') #saves line num 

			    
			    
			    if [ -z "$lineNum" ] # to check if we found the feature Value or not from unique file
			       
			    then # when we cannot find the line num of it then the data is  not added !! 
				
				echo $featureTemp >> featureValues.txt #    then we will add it 
				lineNum=$( grep -n -w  "$featureTemp" featureValues.txt | awk -F ":" '{print $1}') #saves field num 
				
			    else 
				
				featureName=$(awk -v f=$lineNum -F " " ' NR==f {print $1}'  featureValues.txt) # gets data from featureValues.txt (that conatins feature inputs) 
				
				
				# check this ^^^

				
				
			    fi

			    
			done

			# cp $fileName $tempFile # making temporary dataset file to work on

			numOflinesInFeatureValues=$(wc -l featureValues.txt | awk -F " " '{print $1}') # gets num of lines in featureValues.txt
			newString="" 
			
			for ((i=2; i <= $numOflinesInFeatureValues ; i++)) # started from i = 2 cause data starts from line 2
			do
			    tmp=$(awk -v I=$i ' NR==I {print $1 }' featureValues.txt ) # get feature input from featureValues.txt (the unique file)
			    
			    
			    
			    if [ -z "$tmp" ] # cause i used num of Encoded strings that have much data than featureValues.txt
			    then 
				break
			    else
				newString+="$tmp:" # add the feature input to newString
                

			    fi 


			done
                    echo
                    echo "--- $newString -- new string      -"
                    echo "313"
                    awk -F ";" -v F=$fieldNum  -v V=$newString 'NR==1 {$F=V;print }' $tempFile > temp2.txt # change the value of feature in line i to the new value  #new

                    sed -i '' '1s/:/ /g' temp2.txt # to remove  the semicolun  #new

                    # # awk 'NR==1 {print $0}' $tempFile > temp2.txt # to get the first line of dataset  #new
                    # sed -i '' '1s/ /:/g' $tempFile # to replace the space with :  #new

			# sed -i '' '1s/'"$feature;"'/'"$newString"'/' $tempFile # the '' cause im using mac why ? OS X requires the extension to be explicitly specified.
			# the $i refers to line number and the $tmp refers to the data that we want to replace it with $value

			numOflinesInDataset=$(wc -l $tempFile | awk -F " " '{print $1}') # gets num of lines in dataset

			numOflinesInDataset_plusOne=$numOflinesInDataset
			
			
			numOflinesInDataset_plusOne=$(expr $numOflinesInDataset_plusOne + 1) # to use last line 


			
			for ((i=2; i <= $numOflinesInDataset_plusOne ; i++)) # started from i = 2 cause data starts from line 2 (line 1 is header)
			do
			    newString=""
			    tmp2=""
			    for ((j=2; j <= $numOflinesInFeatureValues ; j++)) # started from i = 2 cause data starts from line 2
			    do
				tmp=$(awk -v I=$j ' NR==I {print $1 }' featureValues.txt )
				value=$(awk -F ";" -v I=$i -v F=$fieldNum ' NR==I {print $F }' $tempFile )
				
				if [ "$tmp" == "$value" ] # to check if the data is the same as the feature value
				then
				    newString+="1:" # if it is the same then we will add 1 to the new string #new
				    tmp2=$tmp    
				else
				    newString+="0:" # if it is not the same then we will add 0 to the new string #new

				fi
			    done

                echo " $newString -- new string  346    -" # new
			    #sed -i '' ''"$i"'s/'"$tmp2;"'/'"$newString"'/' $tempFile   # replace the feature name  with its  inputs
                awk -F ";" -v F=$fieldNum -v L=$i -v V=$newString 'NR==L {$F=V;print }' $tempFile >> temp2.txt # change the value of feature in line i to the new value  #new
                # change the value of feature in line i to the new value .'1' to tell awk to print the modified val
                echo
                cat temp2.txt  # new
                
                echo


			    # the '' cause im using mac why ? OS X requires the extension to be explicitly specified.
                # awk -F ";" -v I=$i -v F=$fieldNum -v nst=$newString' NR==I {$F=nst; print $F }' $tempFile >> aaa1.txt # add the feature name to the temp file to get all feature inputs
			    


			done
            sed -i '' 's/:/ /g' temp2.txt # to remove the last char which is ':'  #new
            sed -i '' 's/  / /g' temp2.txt # to remove the last char which is ':'  #new
            sed -i '' 's/ /;/g' temp2.txt # to remove the last char which is ':'  #new

            cp temp2.txt $tempFile # to copy the new file to the temp file  #new
            
			

			rm featureValuesTemp.txt
			rm featureValues.txt

			echo    
			echo "DONE !"
			echo
			sleep 1
			
			

		    else

            echo "Action canceled"
			echo " Something wrong with feature name :)"
			echo "BACK TO MAIN MENU . . . ."
            echo
			sleep 1 
		    fi
		fi


	    else
        echo
		echo Please read the file first
        echo
		sleep 1
		echo Back to main menu ... 
		sleep 1
		

	    fi
            ;;
        m) 
	    if [ $status -ne 0 ] # to check if the file readed


	    then  



		read -p " Please input the name of the feature to be scaled :  "  feature # read the feature name from user
		fieldNum=$( awk -v b="$feature" -F ";" 'NR==1 {for(i=1;i<=NF;i++){if($i ~ b ){print i}}}'  $tempFile )
         #saves field num, if the feature name is not found it will be empty
		if [ -z "$fieldNum" ] # to check if we found the feature or not
		then # the feature doesn't exists
		    
		    echo "The name of categorical feature is wrong :("  
		    
		    
		    
		else # found it maybe
		    
		    value=$(awk -F ";"  -v F=$fieldNum ' NR==2 {print $F }' $tempFile ) # gets the value of feature data to check if it is an integer or not
		    ## here must change to datasetTemp.txt
		    echo "------funm---$fieldNum"
		    
		    if [[ $value =~ ^[0-9]+$ ]]; then # '^' first character, '$' last character, '+' one or more times
			# echo "Value is an integer"
			
			awk  -v col="$fieldNum"  -F ";" 'NR>=2 {print $col }' $tempFile >> temp.txt  
			sort -n temp.txt > temp2.txt # sort the data in temp file and add it to temp2 file

			rm temp.txt # remove temp file Useless
			
			
			min=$(head -n 1 temp2.txt) # get the min value
			max=$(tail -n 1 temp2.txt) # get the max value

			

			echo "min is $min" 
            cat temp2.txt
			echo "max is $max"
            rm temp2.txt # remove temp2 file Useless
        

			
			numlines=$(wc -l $tempFile | awk -F " " '{ print $1 }') # get the number of lines in dataset
			touch temp.txt # create temp file

			awk 'NR==1 {print }' $tempFile > temp.txt # add the first line to temp file
			numlines=$(expr $numlines + 1) # get the number of lines in dataset
			for ((i=2; i <= $numlines ; i++)) # loop in dataset to change the values
			do
			    fieldVal=$(awk -F ";"  -v F=$fieldNum -v L=$i ' NR==L {print $F }' $tempFile ) # get the value of feature in line i
			    

			   
                a=$(echo "$fieldVal - $min" | bc) # get the value - min
                b=$(echo "$max - $min" | bc) # get the max - min
			  
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
                            
                            read -p " Please input the name of the file to save the processed dataset (do not include .txt) :  "  newFile # read the feature name from user
                            newFile=$newFile.txt
                            cp $tempFile $newFile # copy the temp file to the new file
                            echo
                            echo "The processed dataset saved in $newFile"
                            dataSaved=1  # to check if the data saved or not
                            sleep 1
                            echo Back to main menu ...
                            sleep 1
                            


                 
            else
		echo "There is no changes to save" 
		sleep 1
		echo Back to main menu ... 
		sleep 1

            fi
            ;;
        e) 
        if [ $dataSaved -eq 0 ] # to check if the file saved
        then

        read -p " The processed dataset is not saved. Are you sure you want to exist? "  answer 
        if [ $answer == "yes" ] || [ $answer == "y" ] || [ $answer == "Y" ] || [ $answer == "YES" ] || [ $answer == "Yes" ]
        then
            echo Exiting ... 
            sleep 1
            exit 1
        else
            echo Back to main menu ... 
            sleep 1
        fi

        else
         read -p " Are you sure you want to exist? "  answer
            if [ $answer == "yes" ] || [ $answer == "y" ] || [ $answer == "Y" ] || [ $answer == "YES" ] || [ $answer == "Yes" ]
            then
                echo Exiting ... 
                sleep 1
                exit 1
            else
                echo Back to main menu ... 
                sleep 1
            fi


        fi
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