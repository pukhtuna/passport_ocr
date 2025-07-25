import 'package:flutter/material.dart';
import 'package:passport_ocr/widgets/helpers.dart';

class DocumentTile extends StatelessWidget {
  final String title;
  final String status; // done, required, expiring, none
  final VoidCallback? onTap;

  const DocumentTile({
    super.key,
    required this.title,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    IconData trailingIcon = Icons.cancel;
    Color trailingColor = Colors.redAccent;
    Widget? tag;

    if (status == 'done') {
      trailingIcon = Icons.check_circle;
      trailingColor = Colors.greenAccent;
    } else if (status == 'expiring') {
      tag = buildTag('EXPIRING SOON', Colors.orangeAccent);
    } else if (status == 'required') {
      tag = buildTag('REQUIRED', Colors.redAccent);
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3A1D52),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(trailingIcon, color: trailingColor),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        trailing: tag ??
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.6),
              size: 16,
            ),
      ),
    );
  }
}
