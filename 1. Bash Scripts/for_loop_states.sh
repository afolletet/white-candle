#1/bin/bash

# list of US states

states=(
"New York" 
'California'
'Washington'
'Florida'
'Hawaii')

for state in ${states[@]}
do
        if [ $state = 'California' ]
        then
        echo "California is the best" 
        else
        echo "Washingto is rainy, Florida is hot, New York is polluted and HAwaii is far"



fi
done
