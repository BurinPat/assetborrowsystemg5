import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/asset.dart';
import '../../widgets/asset_card.dart';

class StudentAssetList extends StatefulWidget {
  const StudentAssetList({super.key});

  @override
  State<StudentAssetList> createState() => _StudentAssetListState();
}

class _StudentAssetListState extends State<StudentAssetList> {
  final List<Asset> assets = [
    Asset(id: 1, name: 'Fundamental\nElectrical', status: AssetStatus.available),
    Asset(id: 2, name: 'Artificial\nIntelligence', status: AssetStatus.disable),
    Asset(id: 3, name: 'Internet of Things', status: AssetStatus.pending),
    Asset(id: 4, name: 'Book', status: AssetStatus.borrowed),
  ];

  DateTime? borrowDate;
  DateTime? returnDate;

  // ฟังก์ชันเลือกวัน
  Future<void> _pickDate(BuildContext context, bool isBorrowDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isBorrowDate) {
          borrowDate = picked;
        } else {
          returnDate = picked;
        }
      });
    }
  }

  // ฟังก์ชัน Request
  void _showRequestDialog(String assetName) {
    borrowDate = null;
    returnDate = null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Request "$assetName"'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () => _pickDate(context, true),
              child: Text(borrowDate == null
                  ? 'Select Borrow Date'
                  : 'Borrow: ${DateFormat('yyyy-MM-dd').format(borrowDate!)}'),
            ),
            TextButton(
              onPressed: () => _pickDate(context, false),
              child: Text(returnDate == null
                  ? 'Select Return Date'
                  : 'Return: ${DateFormat('yyyy-MM-dd').format(returnDate!)}'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (borrowDate == null || returnDate == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please select both dates')),
                );
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Requested "$assetName"\nBorrow: ${DateFormat('yyyy-MM-dd').format(borrowDate!)}\nReturn: ${DateFormat('yyyy-MM-dd').format(returnDate!)}',
                  ),
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Assets',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black, size: 28),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE5E5E5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Icon(Icons.search, color: Colors.black54),
                  ),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search asset...',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: IconButton(
                      icon: const Icon(Icons.filter_list, color: Colors.black54),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Asset List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: assets.length,
              itemBuilder: (context, index) {
                final asset = assets[index];
                return AssetCard(
                  asset: asset,
                  onEdit: () {
                    // แก้ไข หรือดูรายละเอียด
                    print('View asset ${asset.id}');
                  },
                  onRequest: asset.status == AssetStatus.available
                      ? () => _showRequestDialog(asset.name)
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
