
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/pages/login_page.dart';
import 'package:myapp/presentation/auth/bloc/logout/logout_bloc.dart';
import 'first_page.dart';
import 'second_page.dart';
import 'third_page.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  int index = 0;
  void onTapHandler(int value) {
    setState(() {
      index = value;
    });
  }
  List<Widget> contents = [
    const FirstPage(),
    const SecondPage(),
    const ThirdPage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          BlocConsumer<LogoutBloc, LogoutState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is LogoutLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is LogoutSuccess) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              }
              if (state is LogoutFailed) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Error min"),
                  backgroundColor: Colors.red,
                )
                );
              }
              return IconButton(
                  onPressed: () {
                    context.read<LogoutBloc>().add(LogoutButtonPressed());
                  },
                  icon: const Icon(Icons.logout));
            },
          )
        ],
      ),
      body: contents[index],
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: "increment",
        child: const Icon(Icons.add),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 33,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text("Jason Derulo")
                ],
              ),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.access_alarm), label: 'Test'),
          BottomNavigationBarItem(
              icon: Icon(Icons.accessibility_new_sharp), label: 'Test'),
        ],
        onTap: (value) => onTapHandler(value),
        currentIndex: index,
        selectedItemColor: Colors.red,
      ),
    );
  }
}