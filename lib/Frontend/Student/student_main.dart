import 'package:flutter/material.dart';
import 'student_asset_list.dart';
import 'student_history.dart';
import 'student_request_page.dart';


class StudentMain extends StatefulWidget {
  final String fullName; // ✅ เพิ่มรับชื่อจริงจาก Login
  final String role;     // ✅ เพิ่มรับ role จาก Login

  const StudentMain({
    super.key,
    required this.fullName,
    required this.role,
  });

  @override
  State<StudentMain> createState() => _StudentMainState();
}

class _StudentMainState extends State<StudentMain> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // ✅ ส่งชื่อและ role ให้ Dashboard
    final List<Widget> pages = [
      StudentAssetList(fullName: widget.fullName),
      StudentHistory(fullName: widget.fullName),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.amber[700],
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: 'Assets',
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
