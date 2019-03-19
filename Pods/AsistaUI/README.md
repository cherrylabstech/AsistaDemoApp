# Asista SDK for IOS

[![CI Status](https://img.shields.io/travis/vaisakhcherrylabs/AsistaCore.svg?style=flat)](https://travis-ci.org/vaisakhcherrylabs/AsistaCore)
[![Version](https://img.shields.io/cocoapods/v/AsistaCore.svg?style=flat)](https://cocoapods.org/pods/AsistaCore)
[![License](https://img.shields.io/cocoapods/l/AsistaCore.svg?style=flat)](https://cocoapods.org/pods/AsistaCore)
[![Platform](https://img.shields.io/cocoapods/p/AsistaCore.svg?style=flat)](https://cocoapods.org/pods/AsistaCore)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- iOS 8.0+
- Xcode 10.0+
- Swift 4.2+



## Installing the Asista SDK

AsistaCore is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'AsistaCore'
pod 'AsistaUI'
```

## Getting Started

### SDK Configuration

To begin making calls to the Asista API, you need to register an application on the [Asista Developer Site](https://asista.com) and get credentials for your app.

Then, configure your Xcode with information for the Asista SDK. Locate the **Info.plist** file for your application. Right-click this file and select **Open As > Source Code**

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
## Author

vaisakhcherrylabs, vaisakh.kp@cherrylabs.com


## Contributing

We :heart: contributions. Found a bug or looking for a new feature? Open an issue and we'll respond as fast as we can. Or, better yet, implement it yourself and open a pull request! We ask that you include tests to show the bug was fixed or the feature works as expected.

Please open any pull requests against the `develop` branch. 


## License

AsistaCore is available under the MIT license. See the LICENSE file for more info.
