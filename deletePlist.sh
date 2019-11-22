
##checkout params
##默认接受4个参数
if [ $# -ne 1 ]; then
    echo "参数数量不对"
	exit -1
fi

appName=$1
plistName=${appName%.*}".plist"
rm ../plist_dir/$plistName


