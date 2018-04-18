# ios-directory-listing-swift-realm-objectmapper-alamofire

Created by Michael Steele on 2/20/17.<br />
Copyright © 2017-2018 Michael Steele.<br />
All rights reserved.<br />

Example iOS App source code for a Directory Listing using Swift, Realm, Alamofire, ObjectMapper, Cache, HTTPS, Auth Digest and more.  See Podfile for more libaries.  The example images are large and will be resized and cached on disk and in memory as needed as you swipe.  The individuals are also stored in the Realm database for retrieval as you run the app.  You can create, modify and delete individuals on the server.

<pre>
Instructions:
If you have permission, install the NodeJS sample server locally on your computer.  Follow readme instructions located at:
https://github.com/oo20/nodejs-csv-to-json-api-directory-listing-server

Then make sure you have cocoapods and XCode 9.3 (9E145) installed (uses Swift 4.1).
pod install
Open the workspace with XCode.
Configure the server IP address within the AppManager class.
You will need to specify the proper iP address and have access to the desktop/server from your iPhone.
Run the app in iPhone simulator (for example, iPhone X or iPhone 7 Plus).
If you configured the server incorrectly, you can stop the server, reconfigure, start again and tap the refresh button within the iPhone app.
When done, stop/remove the NodeJS server.
</pre>
