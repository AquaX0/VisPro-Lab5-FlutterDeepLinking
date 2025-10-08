concept checks:
1. What is the difference between a route inside Flutter and a deep link at the Android level?
- flutter route works internally within the app, navigating between pages in the app and the only way to access some pages is to go through other pages. while deep link is an external entry point from the OS level
  that can open your app directly at a certain page.

2. Why does Android need an intent filter?
- so it can declare which URLs, URIs, or actions your app can handle. without it, Android wouldn't know the app exists or can handle myapp:// URLs.

technical understanding:
3. Explain the role of the uni_links package
- 1) it helps connect Android's intent system to Flutter's Dart code
  2) Gives the uriLinkStream to listen for incoming links
  3) getInitialLink() handles app launch from links
  4) Processes links while app is running
  5) Works on Android, iOS, Web, Desktop

4. What happens if a deep link is opened while the app is already running?
- the app doesn't restart. the uriLinkStream immediately receives the new URL. then the _handleIncomingLink() is called instantly, setState() will then update UI to show received link and Navigator.push()
  navigates to DetailScreen. then the screen will immediately transition into a new screen with the parsed data

Debugging Insight:
5. Suppose your adb command opens the app but it doesn’t navigate to the detail page. What part of your code or manifest would you check first, and why?
- Check first: AndroidManifest.xml
Why: If intent-filter is wrong, Android launches app but doesn't deliver deep link data to Flutter.

Verify:

Check second: Flutter app_links setup
Verify:
1) _appLinks.getInitialLink() called in initState() (cold start)
2) _appLinks.uriLinkStream.listen() active (hot start)
3) _handleIncomingLink() actually navigates

summary
deep liking help connect the android's intent filter with flutter navigation so that the android can capture custom URLs through manifest consifguration, then the app_links package streams these URLs to Flutter where they trigger Navigator.push() actions to specific screens. one of the scenario where deep linking is useful for push notification, when users tap a notification about a product sale, the deep link myapp://product/123 instantly opens that specific product page instead of the home screen, improving user experience and engagement. the challenges that i faced while making this is mostly trying to modernized the app from the tutorial given to me, to solve this i use CoPilot to help me make the modernized versions and help with any errors i faced while making this
