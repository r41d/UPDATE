#!/bin/bash

TARGET=/usr/local/sbin/UPDATE

function install_update_script {
	echo "#!/bin/bash" > $TARGET
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
else
	echo "wasn't able to find a matching update script :("
	exit 1
fi

echo "setting $TARGET executable"
chmod +x $TARGET
exit 0

