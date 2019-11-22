### auto updating git repository
#for file in `ls apps`;
#	do
#		if [ "apk" = ${file##*.} ]; then
#			echo $file
#			echo `java -jar apkParser.jar apps"/"$file`
#		fi
#	done
result=`git add -A && git status |grep "apps/"`
commitor=`git config --list |grep "user.name"|sed 's/.*=//g'`
#当前工作目录

#function push_plist_gitHub {
#    git add -A && git stash && git pull origin master && git stash pop stash{0} && git add
#}

if [[ -z $result ]]; then
	echo "Your repository is clearly!"
	git pull origin master
else
	##stash current repository
	git stash
	## update git repository to newly
	git pull origin master
	## reset stash
	git stash pop stash@{0}
	
	## list changes
	#result=`git add -A && git status |grep "apps/"`
	#echo "result = "$result
	#result=($result)

	for file in `git add -A && git status |grep "apps/"`;
		do
			if [ $file = "file:" -o $file = "deleted:" -o $file = "renamed:" -o $file = "modified:" -o ${file##*.} = "ipa" ]; then
				if [ $file = "file:" -o $file = "deleted:" -o $file = "renamed:" -o $file = "modified:" ];then
					firstCmd=$file
					secondCmd=""
				else
					if [ $firstCmd = "file:" -o $firstCmd = "modified:" ]; then
						if [ $firstCmd = "file:" ]; then
							secondCmd=$file
							echo "create new file : "${file##*/}
							java -jar ipaParser.jar $firstCmd $file $commitor
                            
                            echo "test:"$firstCmd $file $commitor
						else
							echo "modified file : " ${file##*/}
							java -jar ipaParser.jar "renamed:" ${file##*/} $file $commitor
						fi
					elif [ $firstCmd = "renamed:" ]; then
						if [ -z $secondCmd ]; then
							secondCmd=$file
						else
							echo "renamed file : "${secondCmd##*/}" to "${file##*/}
							java -jar ipaParser.jar $firstCmd ${secondCmd##*/} $file $commitor
						fi
					else
						echo "deleted file :"${file##*/} 
						java -jar ipaParser.jar $firstCmd ${file##*/}
					fi
				fi
			fi
		done
		
    ## refresh gitlab
	git add -A && git commit -m "upload" && git push origin master
 
    cd ../plist_dir
    ## refresh github
    git stash && git pull origin master && git stash pop stash@{0}
    git add -A && git commit -m "upload plist"
    git push origin master
    cd ..
fi




echo ""
echo ""
echo "更新成功"

exit 0
