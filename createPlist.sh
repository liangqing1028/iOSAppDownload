
##checkout params
##默认接受4个参数
if [ $# -ne 4 ]; then
    echo "参数数量不对"
	exit -1
fi

echo "ready to create plist file"

GITHUB_PREFIX="https://raw.githubusercontent.com/liangqing1028/jisuyongAppIcon/master"
appPackageName=$1
appVersionName=$2
appLabel=$3
appName=$4
plistName=${appName%.*}".plist"
appDownloaderUrl=$GITHUB_PREFIX/$appName

echo "url="$appDownloaderUrl

#存放安装plist文件的目录
dirName="/Users/macadmin/Desktop/project/plist_dir"
TEMPLATE_PLIST="TEMPLATE.plist"

CUR_DIR=`pwd`

##create plist_dir
if [ ! -d "$dirName" ];then
	mkdir -p $dirName
fi

if [ -a $CUR_DIR/$TEMPLATE_PLIST ];then
	cp $CUR_DIR/$TEMPLATE_PLIST $dirName/$plistName
	echo "创建文件$plistName"
else
	echo $TEMPLATE_PLIST"不存在"
fi

echo "dirName:"$dirName
echo "plistName:"$plistName

sed -i "" "s/package_value/${appPackageName}/g" $dirName/$plistName
sed -i "" "s/version_value/${appVersionName}/g" $dirName/$plistName
sed -i "" "s/title_value/${appLabel}/g" $dirName/$plistName
sed -i "" "s#url_value#${appDownloaderUrl}#g" $dirName/$plistName

##回归当前目录
cd $CUR_DIR

echo "complete"
