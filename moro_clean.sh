#!/sbin/sh
#
# Clean app in packages.xml script v2.0
# By morogoku 
# http://www.espdroids.com
#
#
# Usage:
#	moro_clean.sh [apk package]
# 
# example:
#	moro_clean.sh com.sec.android.app.music
#
# In a updater-script file, copy moro_clean.sh to tmp and:
#   run_program("/tmp/moro_clean.sh", "com.sec.android.app.music");
#
#



# Busybox 
if [ -e /su/xbin/busybox ]; then
	BB=/su/xbin/busybox;
else if [ -e /sbin/busybox ]; then
	BB=/sbin/busybox;
else
	BB=/system/xbin/busybox;
fi;
fi;


cd /data/system


if [ -f packages-bak.xml ]; then
	rm -f packages-bak.xml
fi

cp packages.xml packages-bak.xml


run_script(){

	while :
	do
		x=$($BB grep -n ''$ruta'' packages.xml -m 1 | $BB cut -d: -f 1);
		y=$((x + 1));
	
		if [[ ! -z $x ]]; then
			while :
			do
				z=$(echo $($BB awk 'NR=='$y'' packages.xml) | $BB cut -d " " -f 1)
				if [ "$z" == "</package>" ] || [ "$z" == "</updated-package>" ] || [ "$z" == "<updated-package" ]; then
					if [ "$z" == "<updated-package" ]; then
						let "y=y-1";
					fi
					break;
				fi

				let "y=y+1";
			done;
			
			mv packages.xml temp.xml
			$BB sed ''${x},${y}d'' temp.xml > packages.xml
			rm -f temp.xml

			$BB chmod 0660 packages.xml;
			$BB chown 1000.1000 packages.xml;
		else
			break;
		fi
	done;
}


if [[ ! -z $1 ]]; then
	ruta="name=\"$1\""
	run_script;
fi	
	

