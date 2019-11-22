#   iOS端自动打包
#   必须打包前设置好证书
#------------------------------------------------

#if [ $# -ne 1 ]; then
#    echo "请传入工程目录"
#    exit -1
#fi

#配置参数
#取当前时间字符串添加到文件结尾
now=$(date +"_%m月%d日(%H点%M分)")

#工程绝对路径
shell_path=$(cd `dirname $0`; pwd)

echo $shell_path

#project_path
#project_path=$(cd ../; pwd)
project_path="/Users/macadmin/Desktop/project/ShoppingMall/giveUMall"

echo $project_path

#工程名字-----需完善
Project_Name="ShoppingMall"

#配置打包方式Release或者Debug
Configuration="Release"

#archive临时文件夹
ArchiveFile="ArchiveFile"

ExportPath="/Users/macadmin/Desktop/project/iOSAppDownload/apps"


#plist 与 输出文件夹名称,需要与plist文件的名称对应上
#.plist后缀不需要写c ---- 需完善
path_plist="ExportOptions"

#加载各个版本的plist文件，为了实现一个脚本打包所有版本，这里对不同对版本创建了不同的plist配置文件。等号后面是文件路径，一般把plist文件放在与脚本同一级别的文件层中。我这里测试用所以plist文件都一样，实际使用是请分开配置为不同文件
#echo $EBANK_D_DIS_ExportOptionsPlist #打印变量
ExportOptionsPlist="${shell_path}/$path_plist.plist"

if [[ ! -f "$ExportOptionsPlist" ]]; then
    echo ""
    echo "~~~~~~~~~~~~path_plist.plist(未找到)~~~~~~~~~~~~~~~"
    echo ""
    exit 0
fi

if [ -d "/$ArchiveFile" ];then
    rm -rf "$ArchiveFile"
else
    mkdir -p "$ArchiveFile"
fi

if [[ ! -d "$ExportPath" ]];then
    mkdir -p "$ExportPath"
fi

function charge {
    tempValue=`/usr/libexec/PlistBuddy -c "Print :${1}" ${3}`
    #判断tempValue是否为空
    if [[ -n $tempValue ]]; then
        echo $tempValue
    else
        echo ${2}"未设置"
    fi
}

#编译
xcodebuild -workspace "${project_path}/${Project_Name}.xcworkspace" -scheme "${Project_Name}" -configuration "${Configuration}" -archivePath "$ArchiveFile/$Project_Name.xcarchive" archive
#打包
xcodebuild -exportArchive -archivePath "$ArchiveFile/$Project_Name.xcarchive" -exportPath "$ExportPath" -exportOptionsPlist "$ExportOptionsPlist"

cd $ExportPath

rm -f *.plist
rm -f *.log

IPA_FILE="$Project_Name.ipa"

#解包IPA
if [[ -f "$IPA_FILE" ]]; then
    echo "unzip $IPA_FILE begin ..."
    unzip -q "$IPA_FILE" -d "$IPA_DIR"
    if [[ $? != 0 ]]; then
        echo "unzip $IPA_FILE failed"
        exit 2
    else
        echo "unzip $IPA_FILE successed"
    fi
fi
appDir="Payload/`ls Payload`"
infoPlist="${appDir}/Info.plist"
appVersion=$(charge "CFBundleShortVersionString" "版本号" $infoPlist)
#更改ipa名称：工程名+V+版本号
mv $Project_Name.ipa "$Project_Name"_V"$appVersion".ipa
if [[ -d "Payload" ]];then
    rm -rf "Payload"
fi
cd $shell_path

if [ -d "$ArchiveFile" ];then
    rm -rf $ArchiveFile
fi

sh /Users/macadmin/Desktop/project/iOSAppDownload/start.sh
