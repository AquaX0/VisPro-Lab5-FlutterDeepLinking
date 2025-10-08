// checkpoint 4
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  String _status = 'Waiting for link...';

  @override
  void initState() {
    super.initState();
    initDeepLinks();
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    // 1. Handle initial link if app was launched by a deep link
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) _handleIncomingLink(initialUri);

    // 2. Handle links while app is running
    _linkSubscription = _appLinks.uriLinkStream.listen((Uri uri) {
      _handleIncomingLink(uri);
    }, onError: (err) {
      setState(() => _status = 'Failed to receive link: $err');
    });
  }

  void _handleIncomingLink(Uri uri) {
    setState(() => _status = 'Received link: $uri');
    print('🔗 Handling link: $uri');
    print('📍 Host: ${uri.host}');

    if (uri.host == 'details') {
      // Example link: myapp://details/42
      final id = uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : 'unknown';
      print('✅ Navigating to DetailScreen with ID: $id');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DetailScreen(id: id)),
      );
    } else if (uri.host == 'profile') {
      // Example link: myapp://profile/alex
      final username = uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : 'guest';
      print('✅ Navigating to ProfileScreen with username: $username');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen(username: username)),
      );
    } else {
      print('❌ Unknown host: ${uri.host}');
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deep Link Demo',
      home: Scaffold(
        appBar: AppBar(title: Text('Home')),
        body: Center(
          child: Text(_status),
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String id;
  const DetailScreen({required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Details')),
      body: Center(child: Text('You opened item ID: $id')),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final String username;
  const ProfileScreen({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hello, $username!', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
