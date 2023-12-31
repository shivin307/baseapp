import 'package:flutter/material.dart';
import 'package:molten_navigationbar_flutter/molten_navigationbar_flutter.dart';
import 'package:baseapp/local/local_storage.dart'; // Import your shared preferences file
import 'package:baseapp/view/login_page.dart'; // Import your login page

class DesktopPage extends StatefulWidget {
  const DesktopPage({Key? key}) : super(key: key);

  @override
  _DesktopPageState createState() => _DesktopPageState();
}

class _DesktopPageState extends State<DesktopPage> {
  int _selectedIndex = 0;
  late PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
              icon: Icon(Icons.person),
              onPressed: _showUserProfilePopup,
            ),
            actions: [
              IconButton(onPressed: logout, icon: Icon(Icons.logout)),
            ],
            centerTitle: true,
            expandedHeight: 150.0,
            // Adjust as needed
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Your App Title',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
              ),
              // You can customize the FlexibleSpaceBar further as needed
            ),
          ),
          SliverFillRemaining(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              children: [
                Container(color: Colors.red), // Home Screen
                Container(color: Colors.blue), // Search Screen
                Container(color: Colors.green), // Favorites Screen
                Container(color: Colors.yellow), // Profile Screen
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MoltenBottomNavigationBar(
            barHeight: 75,
            domeHeight: 5,
            barColor: Theme.of(context).primaryColorLight,
            borderRaduis: BorderRadius.circular(65),
            domeCircleColor: Theme.of(context).primaryColorDark,
            domeWidth: MediaQuery.of(context).size.width,
            domeCircleSize: 45,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
                _pageController.animateToPage(
                  index,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              });
            },
            selectedIndex: _selectedIndex,
            tabs: [
              MoltenTab(
                // selectedColor: Colors.red,
                // unselectedColor: Colors.green,
                icon: Icon(Icons.home),
                title: Text('Home'),
              ),
              MoltenTab(
                icon: Icon(Icons.search),
                title: Text('Search'),
              ),
              MoltenTab(
                icon: Icon(Icons.favorite),
                title: Text('Favorites'),
              ),
              MoltenTab(
                icon: Icon(Icons.person),
                title: Text('Profile'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> logout() async {
    bool confirmLogout = await _showLogoutConfirmationDialog();
    if (confirmLogout) {
      await setIsLogin(key: 'isLogged', value: false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  Future<void> _showUserProfilePopup() async {
    var email = await getKeyValue(key: 'email');
    var pass = await getKeyValue(key: 'pass');
    var isLogged = await getIsLogin(key: 'isLogged');
    // Add other user info retrieval logic here

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("User Profile"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Email: $email"),
              Text("Password: $pass"),
              Text("IsLogin: $isLogged"),
              // Add other user info fields here
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the popup
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _showLogoutConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // User does not want to logout
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User wants to logout
              },
              child: Text("Logout"),
            ),
          ],
        );
      },
    );
  }
}
