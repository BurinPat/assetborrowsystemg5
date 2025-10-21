import 'package:flutter/material.dart';
import 'lecturer_asset_list.dart';
import 'lecturer_dashboard.dart';
import 'lecturer_history.dart';

class LecturerMain extends StatefulWidget {
  const LecturerMain({super.key});

  @override
  State<LecturerMain> createState() => _LecturerMainState();
}

class _LecturerMainState extends State<LecturerMain> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const LecturerAssetList(),
    const LecturerDashboard(),
    const LecturerHistory(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.blue[700],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: 'Assets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }
}
