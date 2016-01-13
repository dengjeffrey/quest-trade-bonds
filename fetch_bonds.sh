#!/bin/bash
# $ sh fetch_bonds.sh 10000
current_date=$(date "+%Y-%m-%d")
download_file="recent_pdf.pdf"

output_file="bonds-"
output_file+=$current_date
output_file+=".txt"
echo $output_file
url="http://campaigns.questrade.com/Libraries/bonds/Questrade_Bonds_List.sflb.ashx -O "$download_file

wget $url
pdftotext -table $download_file $output_file

while IFS= read -r line
do
    
    # line without the first 10 letters, since the CUSIP is 9 letters and the occasional
    # 11 letters when the second last letter is a W or F due to spacing
    CUSIP_LENGTH="11"
    shortened_line=$( echo "$line" | cut -c "$CUSIP_LENGTH"- )

    arr=($shortened_line)
    
    # This line contains words
    if [ ${#arr[@]} > 0 ] 
    then
    
	    second_column=${arr[0]}
	    second_column=${second_column//,}
	    
        # Second column is a number?
	    if [[ ($second_column =~ ^-?[0-9]+$) && $second_column -le $1 ]]
	    then
            echo "$line"
	    fi
	fi
done <"$output_file"
