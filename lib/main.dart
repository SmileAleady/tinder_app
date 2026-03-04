import 'package:flutter/material.dart';
import 'package:tinder_app/page/home_page.dart';
import 'package:tinder_app/page/like_page.dart';
import 'package:tinder_app/page/my_message_page.dart';
import 'package:tinder_app/page/profile_page.dart';
import 'package:tinder_app/page/search_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  late PageController _pageController;

  double itemWidth = 0;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    itemWidth = MediaQuery.of(context).size.width / 5;
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              if (_selectedIndex != 4) _customAppBar(),
              Expanded(
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  children: const [
                    HomePage(),
                    SearchPage(),
                    LikePage(),
                    MyMessagePage(),
                    ProfilePage(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: SizedBox(
              width: itemWidth,
              child: Icon(
                Icons.local_fire_department,
                color: _selectedIndex == 0 ? Colors.red : Colors.grey,
                size: 32,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: itemWidth,
              child: Icon(
                Icons.grid_view,
                color: _selectedIndex == 1 ? Colors.red : Colors.grey,
                size: 28,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: itemWidth,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Icon(
                      Icons.auto_awesome,
                      color: _selectedIndex == 2 ? Colors.red : Colors.grey,
                      size: 32,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '20',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              // color: Colors.yellow,
              width: itemWidth,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Icon(
                      Icons.chat_bubble,
                      color: _selectedIndex == 3 ? Colors.red : Colors.grey,
                      size: 28,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: itemWidth / 2 - 15,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: itemWidth,
              child: Icon(
                Icons.person,
                color: _selectedIndex == 4 ? Colors.red : Colors.grey,
                size: 28,
              ),
            ),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }

  Widget _customAppBar() {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top,
        16,
        12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Tinder Logo
          Expanded(child: SizedBox()),
          Center(
            child: SizedBox(
              height: 40,
              width: 200,
              child: Center(
                child: Text(
                  textAlign: TextAlign.center,
                  '🔥 tinder',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          // Shield Icon
          Expanded(child: SizedBox()),
          (_selectedIndex == 0 || _selectedIndex == 3)
              ? Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[600]!, width: 1),
                  ),
                  child: Icon(
                    _selectedIndex == 0 ? Icons.light : Icons.shield,
                    color: Colors.grey,
                    size: 20,
                  ),
                )
              : SizedBox(width: 40, height: 40),
        ],
      ),
    );
  }

  //   Widget _customAppBar() {
  //     return Container(
  //       height: 80,
  //       padding: const EdgeInsets.only(top: 30, left: 16, right: 16),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.grey.withOpacity(0.5),
  //             spreadRadius: 1,
  //             blurRadius: 5,
  //             offset: const Offset(0, 3), // changes position of shadow
  //           ),
  //         ],
  //       ),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Expanded(
  //             child: Center(
  //               child: Row(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   const Icon(Icons.favorite, color: Colors.red, size: 28),
  //                   const SizedBox(width: 8),
  //                   const Text(
  //                     'Tinder',
  //                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           ElevatedButton.icon(
  //             onPressed: () {
  //               // Handle button action
  //             },
  //             icon: const Icon(Icons.settings),
  //             label: const Text('设置'),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
}
