import 'package:flutter/material.dart';
import '../../widgets/profile_menu.dart';

class LecturerRequestAsset extends StatefulWidget {
  final String fullName;
  const LecturerRequestAsset({super.key, required this.fullName});

  @override
  State<LecturerRequestAsset> createState() => _LecturerRequestAssetState();
}

class _LecturerRequestAssetState extends State<LecturerRequestAsset> {
  final List<Map<String, dynamic>> historyData = [
    {
      'name': 'Camera',
      'borrowDate': '18/10/25',
      'returnDate': '19/10/25',
      'borrowBy': 'Somchai',
      'status': 'Pending',
      'color': Colors.amber.shade300,
      'textColor': Colors.white,
    },
    {
      'name': 'Tripod',
      'borrowDate': '19/10/25',
      'returnDate': '20/10/25',
      'borrowBy': 'Robert',
      'status': 'Pending',
      'color': Colors.amber.shade300,
      'textColor': Colors.white,
    },
    {
      'name': 'Microphone',
      'borrowDate': '-',
      'returnDate': '-',
      'borrowBy': 'Tony Stark',
      'status': 'Rejected',
      'color': Colors.red.shade300,
      'textColor': Colors.white,
    },
    {
      'name': 'Projector',
      'borrowDate': '10/10/25',
      'returnDate': '11/10/25',
      'borrowBy': 'Bruce Wayne',
      'status': 'Returned',
      'color': Colors.grey,
      'textColor': Colors.white,
    },
  ];

  // ✅ ฟังก์ชันกด Approve / Reject
  void _approveRequest(int index) {
    final item = filteredData[index];
    setState(() {
      filteredData.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ Approved request for ${item['name']}'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _rejectRequest(int index) {
    final item = filteredData[index];
    setState(() {
      filteredData.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('❌ Rejected request for ${item['name']}'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // 📋 กรองเฉพาะ Pending
  late List<Map<String, dynamic>> filteredData;

  @override
  void initState() {
    super.initState();
    filteredData = historyData.where((item) => item['status'] == 'Pending').toList();
  }

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
              icon:
                  const Icon(Icons.account_circle, color: Colors.black, size: 32),
              onPressed: () async {
                final RenderBox button =
                    context.findRenderObject() as RenderBox;
                final RenderBox overlay =
                    Overlay.of(context).context.findRenderObject() as RenderBox;
                final Offset position =
                    button.localToGlobal(Offset.zero, ancestor: overlay);

                await ProfileMenu.show(context, position,
                    fullName: widget.fullName);
              },
            );
          },
        ),
        title: const Text(
          'Requests',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // 📋 แสดงรายการ Pending เท่านั้น
      body: filteredData.isEmpty
          ? const Center(
              child: Text(
                'No pending requests 🎉',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                final item = filteredData[index];

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
                      // 🔹 หัวข้อ + ปุ่ม Approve / Reject
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check_circle,
                                    color: Colors.green, size: 28),
                                tooltip: 'Approve',
                                onPressed: () => _approveRequest(index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.cancel,
                                    color: Colors.red, size: 28),
                                tooltip: 'Reject',
                                onPressed: () => _rejectRequest(index),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // 🔹 รายละเอียดผู้ยืม
                      Text(
                        'Borrowed by: ${item['borrowBy']}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      Text(
                        'Borrow date: ${item['borrowDate']}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      Text(
                        'Return date: ${item['returnDate']}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 8),

                      // 🔹 สถานะ Pending
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade300,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Pending',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
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
