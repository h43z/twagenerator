#!/bin/sh
set -e

main(){
	test -n "$1" && ICON="$1" || usage
	test -n "$2" && APPNAME="$2" || usage
	test -n "$3" && PACKAGENAME="$3" || usage
	test -n "$4" && DOMAIN="$4" || usage
	test -n "$5" && KEYSTORE="$5" || usage
	test -n "$6" && STOREPASS="$6" || usage
	test -n "$7" && ALIAS="$7" || usage
	test -n "$8" && KEYPASS="$8" || usage

	test -e $KEYSTORE || (echo "Keystore $KEYSTORE: No such file"; exit 2)
	test -e $ICON || (echo "Icon $ICON: No such file"; exit 2)

	cp $ICON android/app/src/main/res/drawable/ic_launcher.png

	file="app/build.gradle"
	m4 -D _PACKAGENAME=$PACKAGENAME -D _KEYSTORE="$(pwd)/$(basename $KEYSTORE)" -D _STOREPASS=$STOREPASS -D _ALIAS=$ALIAS -D _KEYPASS=$KEYPASS templates/$file > android/$file

	file="app/src/main/AndroidManifest.xml"
	m4 -D _DOMAIN=$DOMAIN -D _PACKAGENAME=$PACKAGENAME templates/$file > android/$file

	file="app/src/main/res/values/strings.xml"
	m4 -D _DOMAIN=$DOMAIN -D _APPNAME=$APPNAME templates/$file > android/$file

	(cd android && ./gradlew clean assembleRelease)

	cp android/app/build/outputs/apk/release/app-release.apk twa-app.apk
	echo "\n[generated] ./twa-app.apk"

	SHA256=$(keytool -list -v -keystore $KEYSTORE -alias $ALIAS  -storepass $STOREPASS 2>/dev/null | grep "SHA256:" | cut -d" " -f3)
	file="assetlinks.json"
	m4 -D _PACKAGENAME=$PACKAGENAME -D _SHA256=$SHA256 templates/assetlinks.json > $file
	echo "[generated] ./assetlinks.json\n"
}

usage(){
	echo "usage: ${0##*/} icon appname packagename domain keystore storepass alias keypass"
	exit 1
}

main "$@"
