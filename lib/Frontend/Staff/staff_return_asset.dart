import 'package:flutter/material.dart';
import '../../widgets/profile_menu.dart';

class StaffReturnAsset extends StatefulWidget {
  final String fullName; // ✅ รับชื่อผู้ใช้จาก parent
  const StaffReturnAsset({super.key, required this.fullName});

  @override
  State<StaffReturnAsset> createState() => _StaffReturnAssetState();
}

class _StaffReturnAssetState extends State<StaffReturnAsset> {
  final List<Map<String, dynamic>> borrowedItems = [
    {
      'id': 1,
      'itemName': 'Camera',
      'borrowDate': '18/10/25',
      'returnDate': '20/10/25',
      'borrowedBy': 'Robert Downey',
      'approvedBy': 'MA Asset',
      'status': 'Borrowed',
      'color': Colors.blue,
      'textColor': Colors.white,
    },
    {
      'id': 2,
      'itemName': 'Microphone',
      'borrowDate': '19/10/25',
      'returnDate': '21/10/25',
      'borrowedBy': 'Tony Stark',
      'approvedBy': 'Mr.Admin',
      'status': 'Borrowed',
      'color': Colors.blue,
      'textColor': Colors.white,
    },
    {
      'id': 3,
      'itemName': 'Tripod',
      'borrowDate': '20/10/25',
      'returnDate': '23/10/25',
      'borrowedBy': 'Bruce Wayne',
      'approvedBy': 'Mr.Admin',
      'status': 'Borrowed',
      'color': Colors.blue,
      'textColor': Colors.white,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.account_circle, color: Colors.black, size: 32),
              onPressed: () async {
                final RenderBox button = context.findRenderObject() as RenderBox;
                final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
                final Offset position = button.localToGlobal(Offset.zero, ancestor: overlay);
                await ProfileMenu.show(context, position, fullName: widget.fullName);
              },
            );
          },
        ),
        title: const Text(
          'Return Asset',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: borrowedItems.length,
        itemBuilder: (context, index) {
          final item = borrowedItems[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ชื่อ + Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Name: ${item['itemName']}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: item['color'],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item['status'],
                        style: TextStyle(
                          color: item['textColor'],
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Borrow date: ${item['borrowDate']}', style: TextStyle(color: Colors.grey[700])),
                Text('Return date: ${item['returnDate']}', style: TextStyle(color: Colors.grey[700])),
                Text('Borrowed by: ${item['borrowedBy']}', style: TextStyle(color: Colors.grey[700])),
                Text('Approved by: ${item['approvedBy']}', style: TextStyle(color: Colors.grey[700])),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${item['itemName']} returned successfully'),
                          backgroundColor: const Color(0xFF22C55E),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF22C55E),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      elevation: 0,
                    ),
                    child: const Text('Return', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
