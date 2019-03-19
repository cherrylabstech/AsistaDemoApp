
# Asista Sample App for IOS SDK

#### The demo app demonstrates how to use the asista Android SDK into your mobile application.


##### The following asista SDK features are demonstrated in the demo app.
- Registering or logging into asista.
- Ticket creation.
- View Ticket list.
- View Knowledge Base.
- View Assets.


## Demo App Configuration

Configure your Xcode with information for the Asista SDK. Locate the **Info.plist** file in the demo  application. Right-click this file and select **Open As > Source Code**

Add the following code snippet, replacing the placeholders within the square brackets (`[]`) with your app’s information from the developer dashboard. (Note: Do not include the square brackets)

```
<key>Asista</key>
<dict>
<key>appKey</key>
<string>[appKey]</string>
<key>appSecret</key>
<string>[appSecret]</string>
<key>tenantUrl</key>
<string>[https://example.asista.com]</string>
</dict>
```

## Talk to Us
Visit our GitHub [Issues](https://github.com/cherrylabstech/asista-sdk-ios/issues) to leave feedback and to connect with other users of the SDK.

## Contributing

We :heart: contributions. Found a bug or looking for a new feature? Open an issue and we'll respond as fast as we can. Or, better yet, implement it yourself and open a pull request! We ask that you include tests to show the bug was fixed or the feature works as expected.

Please open any pull requests against the `develop` branch. 

## License
 Use of this software is subject to important terms and conditions as set forth in the License file
