import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart'; // To send the request

void main() => runApp(CostamWallpapers());

class CostamWallpapers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.purple,
        accentColor: Colors.pinkAccent,
      ),
      home: WallpaperHome(),
    );
  }
}

class WallpaperHome extends StatefulWidget {
  @override
  _WallpaperHomeState createState() => _WallpaperHomeState();
}

class _WallpaperHomeState extends State<WallpaperHome> {
  // ADD YOUR WALLPAPER IMAGE LINKS HERE
  final List<String> wallpapers = [
    "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe", 
    "https://images.unsplash.com/photo-1579546929518-9e396f3cc809",
    "https://images.unsplash.com/photo-1550684848-fac1c5b4e853",
    "https://images.unsplash.com/photo-1557683316-973673baf926",
  ];

  @override
  void initState() {
    super.initState();
    checkFirstSeen();
  }

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (!_seen) {
      await prefs.setBool('seen', true);
      _showUnicornGreeting();
    }
  }

  void _showUnicornGreeting() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.pinkAccent, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("⭐ SYSTEM MESSAGE ⭐", style: TextStyle(color: Colors.pinkAccent, fontSize: 12)),
                SizedBox(height: 10),
                Text("Hi!!! Unicorn", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, decoration: TextDecoration.none)),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.pinkAccent),
                  onPressed: () => Navigator.pop(context),
                  child: Text("Hey!"),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _sendRequest() {
    // This creates a popup so she can tell you what she wants
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      builder: (context) => Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Request a Live Wallpaper", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              decoration: InputDecoration(hintText: "Describe the wallpaper..."),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Request sent to the dev!")));
              },
              child: Text("Send to Bro"),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("COSTAM WALLZ", style: TextStyle(letterSpacing: 2)),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(12),
        itemCount: wallpapers.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, 
          crossAxisSpacing: 10, 
          mainAxisSpacing: 10,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(wallpapers[index], fit: BoxFit.cover),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _sendRequest,
        label: Text("Request Live"),
        icon: Icon(Icons.bolt),
        backgroundColor: Colors.pinkAccent,
      ),
    );
  }
}
