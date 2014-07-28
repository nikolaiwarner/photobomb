## To build source

- bower install
- gulp


## To run in cordova

Make a new CCA app and link the www dir to the app:
- cca create photobomb --link-to=/Users/nikolaiwarner/repositories/photobomb/www

- cca prepare
- cca build android
- cca run android
- cca push --watch --target=[ip address]
