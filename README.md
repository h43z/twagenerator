## twagenerator
#### Shell script that generates an app using [Trusted Web Activities](https://developers.google.com/web/updates/2019/02/using-twa)

Run twagenerator.sh with all parameters

```
$ git clone https://github.com/h43z/twagenerator && cd twagenerator
% sh twagenerator.sh     
usage: twagenerator.sh icon appname packagename domain keystore storepass alias keypass
```
Example
```
% sh twagenerator.sh ~/icons/512.png pushmore com.lol pushmore.43z.one $HOME/documents/test.keystore keystorepass123 upload uploadpass123

BUILD SUCCESSFUL in 4s
28 actionable tasks: 25 executed, 3 up-to-date

[generated] ./twa-app.apk
[generated] ./assetlinks.json
```
Put the JSON file into .well-known/asetlinks.json at your pwa domain.
