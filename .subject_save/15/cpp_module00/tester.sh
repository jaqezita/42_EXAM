# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    tester.sh                                          :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jcluzet <jcluzet@student.42.fr>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/06/20 02:26:11 by jcluzet           #+#    #+#              #
#    Updated: 2022/05/15 21:19:23 by jcluzet          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

MAIN='main.cpp'
MAIN1='../.system/verif/main.cpp'

index=0

if [ -e traceback ]
then
    rm traceback
fi

cd .system/verif
clang++ -Wall -Wextra -Werror -std=c++98 -o source $MAIN Warlock.cpp
./source | cat -e > sourcexam       #TESTING
rm source
cd ../../rendu
{
clang++ -Wall -Wextra -Werror -std=c++98 -o final $MAIN1 Warlock.cpp
}  &>../.system/verif/traceback
# if there is a traceback file, exit this script
# if [ -e ../.system/verif/traceback ]
# then
# 	mv ../.system/verif/traceback ../traceback
# 	exit 1
# fi
{
./final | cat -e > finalexam        #TESTING
mv finalexam ../.system/verif/
rm final
}  &>/dev/null
cd ../.system/verif
DIFF=$(diff sourcexam finalexam)
# echo "" >> traceback
if [ "$DIFF" != "" ]
then
		index=$(($index + 1))
		echo "<-------------- OUR OUTPUT ------------>" >> traceback
		cat sourcexam >> traceback
		echo '\n' >> traceback
		if [ -e finalexam ]
		then
		echo "<-------------- MUST BE : ------------>\n\n" >> traceback
		cat finalexam >> traceback
		else
		echo "" >> traceback
		fi
		# echo '\n' >> traceback
		echo "<--------------    DIFF :   ------------>" >> traceback
		# echo "DIFF : " >> traceback
		echo "$DIFF" >> traceback
		echo "Little reminder: Here you must have a Warlock.cpp & Warlock.hpp files." >> traceback
fi
rm finalexam

if [ $index -eq 0 ]
then
	touch passed
fi
{
mv traceback ../../traceback
}	&>/dev/null
rm sourcexam
