path=$(pwd)
prgm=$1.js

running=`forever list | grep "$path/$prgm"`

cmd=restart
if [ ${#running} == 0 ]; then
	cmd=start
fi

forever $cmd $path/$prgm
