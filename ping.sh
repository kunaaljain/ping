filename="$1"
number="$2"
if [ ! -f data ]
then
	echo "First run: Making data file for you"
	echo "Date,Name,Count,Size,Packet Loss,Avg RTT" > data
fi

if [ ! -f "$1" ]
then
	echo "Please provide hostname file"
	exit 1
fi

if [[ ! "$2" ]]
then
	echo "Please provide how many time you want to ping"
	exit 1
fi

while read -r line
do
	name=$line
	echo "Starting for $name:"
	for j in 64 128 256 512 1024 2048; do
		echo "Doing for $j Bytes:"
		for i in `seq 1 "$2"`; do
			echo "Iteration Number $i"
			url="http://www.spfld.com/cgi-bin/ping?remote_host=$name&dns=on&count=10&size=$j"
			filen=$i$name$2$j
			data=`wget $url -qO $filen`
			packetloss=`sed -n -e '4 s/.*\(, \([[:digit:]]\+\)% packet loss\).*/\2/p' "$filen"`
			avgrtt=`sed -n -e '5 s/\(.[^\/]*\/.[^\/]*\/.[^\/]*\/.[^\/]*\/\)\(.[^\/]*\).*/\2/p' "$filen"`
			echo $(date),$name,"10",$j,$packetloss,$avgrtt >> data
			echo $(date),$name,"10",$j,$packetloss,$avgrtt
			echo "Done"
			`rm "$filen"`
		done
	done
done < "$filename"
