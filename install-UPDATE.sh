#!/bin/sh

FOLDER=/usr/local/sbin
TARGET=$FOLDER/UPDATE

install_update_script () {
	if ! [ -d $FOLDER ]; then
		echo "creating $FOLDER"
		mkdir -p $FOLDER
	fi
	echo "#!/bin/sh" > $TARGET
	echo $1 >> $TARGET
}

if [ -x "$(command -v apt)" ]; then
	echo "installing update script for apt"
	install_update_script "apt update && apt upgrade && apt autoremove"
	if [ -x "$(command -v snap)" ]; then
		echo "adding snap update"
		echo "snap refresh" >> $TARGET
	fi
elif [ -x "$(command -v emerge)" ]; then
	echo "installing update script for emerge"
	install_update_script "emerge --sync && emerge -DNuav @world"
elif [ -x "$(command -v yum)" ]; then
	echo "installing update script for yum"
	install_update_script "yum update"
elif [ -x "$(command -v apk)" ]; then
	echo "installing update script for apk"
	install_update_script "apk update && apk upgrade"
else
	echo "wasn't able to find a matching update script :("
	exit 1
fi

echo "setting $TARGET executable"
chmod +x $TARGET
exit 0

