import 'package:flutter/material.dart';

class LecturerDashboard extends StatefulWidget {
  const LecturerDashboard({super.key});

  @override
  State<LecturerDashboard> createState() => _LecturerDashboardState();
}

class _LecturerDashboardState extends State<LecturerDashboard> {
  int _selectedIndex = 0;

  final List<String> _pageTitles = ['Dashboard', 'Items', 'History', 'Home'];

  final pages = const [
    HomePage(),
    Center(child: Text('Items Page')),
    Center(child: Text('History Page')),
    Center(child: Text('Home Page')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_selectedIndex]),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Items'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const stats = [
    {'title': 'Total Items', 'count': 156},
    {'title': 'Borrowed', 'count': 43},
    {'title': 'Overdue', 'count': 8},
  ];

  static final recentItems = [
    RecentItemData(
      'MacBook Pro',
      'Alex Smith',
      'Oct 20 - Oct 27',
      'Borrowed',
      Colors.amber,
    ),
    RecentItemData(
      'iPad Air',
      'Emma Wilson',
      'Oct 15 - Oct 22',
      'Returned',
      Colors.green,
    ),
    RecentItemData(
      'DSLR Camera',
      'James Brown',
      'Oct 10 - Oct 17',
      'Overdue',
      Colors.red,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.of(context).size.width - 48) / 3;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: stats
                .map(
                  (s) => StatCard(
                    title: s['title'] as String,
                    count: s['count'] as int,
                    width: width,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 30),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Recent Items',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 4),
              Container(width: 500, height: 1, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 15),
          Expanded(
            child: ListView.separated(
              itemCount: recentItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, i) => RecentItemCard(item: recentItems[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final int count;
  final double width;

  const StatCard({
    super.key,
    required this.title,
    required this.count,
    required this.width,
  });

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    padding: const EdgeInsets.symmetric(vertical: 16),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
      ],
    ),
    child: Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    ),
  );
}

class RecentItemData {
  final String title, user, dateRange, status;
  final Color color;

  const RecentItemData(
    this.title,
    this.user,
    this.dateRange,
    this.status,
    this.color,
  );
}

class RecentItemCard extends StatelessWidget {
  final RecentItemData item;

  const RecentItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    Color darken(Color color, [double amount = .3]) {
      final hsl = HSLColor.fromColor(color);
      return hsl
          .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
          .toColor();
    }

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${item.user} • ${item.dateRange}',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: item.color.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            item.status,
            style: TextStyle(
              color: darken(item.color),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
