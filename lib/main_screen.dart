import 'package:bidding_bazar/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bidding_bazar/features/create_listing/presentation/screens/create_listing_screen.dart';
import 'package:bidding_bazar/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:bidding_bazar/features/notification/presentation/screens/notification_screen.dart';
import 'package:bidding_bazar/features/product/presentation/screens/home_screen.dart';
import 'package:bidding_bazar/profile/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      // Subscribe to notifications when the user is logged in
      context.read<NotificationBloc>().add(SubscribeToNotifications(authState.user.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bidding Bazar'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        actions: [
          BlocBuilder<NotificationBloc, NotificationState>(
            builder: (context, state) {
              return IconButton(
                icon: Badge(
                  label: Text('${state.unreadCount}'),
                  isLabelVisible: state.unreadCount > 0,
                  child: const Icon(Icons.notifications_none_outlined),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotificationScreen()));
                },
              );
            },
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () async {
                // Navigate and wait for a result to refresh the list
                final result = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CreateListingScreen()));
                if (result == true && mounted) {
                   // This is a simple way to trigger a refresh.
                   // A more advanced way would be to use a dedicated BLoC event.
                   setState(() {
                      // This forces a rebuild of the HomeScreen widget if it's the current screen
                   });
                }
              },
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}