import 'package:db/screens/new_user.dart';
import 'package:db/screens/tasks.dart';
import 'package:db/screens/users.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void addUserHandler(context) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => const NewUserScreen(),
    //     fullscreenDialog: true,
    //   ),
    // );
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return const NewUserScreen();
        },
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.decelerate;
          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(
            CurveTween(curve: curve),
          );

          var offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Task Master"),
          actions: [
            IconButton(
              onPressed: () => addUserHandler(context),
              icon: const Icon(Icons.add),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text("Users"),
              ),
              Tab(
                child: Text("Tasks"),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            UsersScreen(),
            TasksScreen(),
          ],
        ),
      ),
    );
  }
}
