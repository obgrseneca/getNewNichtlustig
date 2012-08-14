#!/bin/bash
# Copyright (c) 2012 Oliver Burger obgr_seneca@mageia.org
#
# This file is part of getNewNichtlustig.
#
# getNewNichtlustig is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# getNewNichtlustig is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with getNewNichtlustig.  If not, see <http://www.gnu.org/licenses/>.


# fetch new nichtlustig strips when available
# change into ruthe comic strip safe dir and clean up existing index.html files
cd ~/Bilder/nichtlustig.de/
rm -f main.html

# get max index of already downloaded ruthe strips
max=0
for i in $(ls *.jpg | cut -d "_" -f 2 | cut -d "." -f 1); do
	if [ $i -gt $max ]; then
		max=$i
	fi
done

# download the ruthe index.html file and get the index of the comic strip
# if this is greater of the max index download all new files
wget http://www.nichtlustig.de/main.html 2>&1 > /dev/null
new=$(cat main.html | grep link\ rel | grep http://static.nichtlustig.de/comics/full | cut -d '"' -f 4 | cut -d '/' -f 6 | cut -d '.' -f 1)
if [ $new -gt $max ]; then
	let firstnew=$max+1
	for i in $(seq $firstnew $new); do
		wget http://static.nichtlustig.de/comics/full/$i.jpg
	done
else
	echo "No new strips"
fi

# clean up and leave ruthe safe dir again
rm -f main.html
cd - 2>&1 > /dev/null
