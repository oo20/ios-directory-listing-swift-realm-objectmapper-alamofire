# ios-directory-listing-swift-realm-objectmapper-alamofire

Created by Michael Steele on 2/20/17.<br />
Copyright © 2017 Michael Steele.<br />
All rights reserved.<br />

Example iOS App source code for a Directory Listing using Swift, Realm, Alamofire, ObjectMapper, STXImageCache and more.  See Podfile for more libaries.  The example images are large and will be resized and cached on disk and in memory as needed as you swipe.  The individuals are also stored in the Realm database for retrieval as you run the app.  You can create, modify and delete individuals temporarily.

<pre>
Instructions:
If you have permission, install the NodeJS sample server locally on your computer.  Follow readme instructions located at:
https://github.com/oo20/nodejs-csv-to-json-api-directory-listing-server

Then make sure you have cocoapods and XCode 8.2.1 installed.
pod install
Open the workspace with XCode.
Configure the baseURL within the AppManager class.
Run the app in iPhone simulator or iPhone (you will need to specify the proper iP address and have access to the desktop from your iPhone).
When done, stop/remove the NodeJS server.
</pre>
