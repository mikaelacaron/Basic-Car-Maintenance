# App Store Listing

## Overview

This article contains suggested texts and settings for the App Store listing, which will be set up in App Store Connect after Hacktoberfest.

Here's the Apple developer site covering how to set up an app's product page, as well as the many other things you can do with App Store Connect: https://developer.apple.com/app-store-connect/

### App Information

Set up the app's name and subtitle under **General** ▸ **App Information** in the **Localizable Information** section at the top of the page. You have a maximum of 30 characters for each field. According to [Appfigures](https://appfigures.com/resources/guides/app-name-optimization), you should portion out keywords between the name and the subtitle for optimal ASO, App Store Optimization, which is the black art of doing everything you can in your App Store listing to make it highly visible in the Store.

**Name**: `Basic Auto Vehicle Maintenance`

**Subtitle**: `Service Records & Mile Tracker`

The remainder of the **General Information** on this page gets set when the app is first added to App Store Connect and cannot be changed thereafter, although primary and secondary category can be changed when releasing a new version if desired. 

- **Bundle ID** is set in Xcode and read from the app's build.
- **SKU** (which stands for Stock Keeping Unit) is an ID you assign and can see later in reports. It's not visible to users either in the Store or in your app, so we can use whatever short code we want here, like `BasicCarMaintenance`.
- **Content Rights** is a dialog in which you say whether or not your app uses third-party content and affirm that if it does, you have the legal rights to use this content. Currently, `No, it does not contain, show, or access third-party content` is the correct setting for this app.
- **Age Rating** contains a list of potentially concerning types of content your app may contain, such as profanity or simulated gambling, and you choose whether your app contains None, Infrequent/Mild, or Frequent/Intense amounts of that type of content. For this app, each type can be set to `None`. Next, you're asked whether your app offers unrestricted web access or instances of gambling. For this app, these should both be answered **No**. The final screen here shows the Age Rating based on your selections, which should be Age 4+ for this app. In the Advanced section, one can also choose to set the app as Made for Kids (which cannot ever be undone once it's been set and apparently also cannot be made available on visionOS) or Restrict to 17+. Neither of this make sense for this Basic Car Maintenance app.
- **License Agreement** is where you can use Apple's standard End User License Agreement (EULA) or paste in your own, then select the countries or regions to which your own custom agreement should apply. For this app, we can simply `Apply Apple's standard end user license agreement (EULA) to all countries or regions`.
- **Primary Language** is set in the build and will be `English (U.S.)` for this app.
- **Category** Looking at potential competitors for this app, there's no clear winner as to category. `Utilities` could be a logical choice, as could `Lifestyle`. At the time of this writing, Apple currently shows Lifestyle in Top Categories (without needed to tap See All) although it does not show Utilities, so this suggests we should pick `Lifestyle`. It's not clear whether there's a benefit to setting the optional Secondary category, so let's leave this unset.

### Version Information
Enter the following metadata on the version information page, which appears under **iOS App** at the top left-hand side of the App Store tab in App Store Connect

#### Description
`Basic Auto Vehicle Maintenance lets you easily log repairs and routine service. You can also track odometer readings, handy for business travel or just to figure out how far your fuel gets you.`

`This app began as a Hacktoberfest 2023 project and remains open source, maintained by Mikaela Caron. Look for mikaelacaron / Basic-Car-Maintenance and come contribute!`

#### Keywords
You have 100 characters of keyword space, which get combined with the Name and Subtitle fields discussed above when a user searches the App Store. Ariel Michaeli of Appfigures recently advised to put the more important keywords closer to the start of this field. Separate keywords with commas; omit spaces. 

Suggested: `car,van,motorcycle,bike,care,repair,manage,easy,simple,oil,change,tire,rotation,record,fuel,gas,log`
