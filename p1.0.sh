
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
        
        if [ -e $user_var.txt ] # checks if file exists
            then
        
              echo "ok"
              status=1
        else
             echo "file does not exist :( "
        fi
        dataFields=$( awk -F ";" 'NR ==1 {print NF }' $user_var.txt)  # get num of data fields
        echo $dataFields
 
   
		

sleep 2
          	;;
		
		p)
        if [ $status -ne 0 ] # to check if the file readed

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
                echo p 
        else
             echo Please read the file first
            sleep 1
             echo Back to main menu ... 
             sleep 1
             clear 

        fi
        ;;
        o) 
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