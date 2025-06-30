import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final double value;
  final Color color;

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(Icons.account_balance_wallet, color: color),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Rp ${value.toStringAsFixed(0)}",
            style: TextStyle(color: color, fontSize: 16)),
      ),
    );
  }
}
