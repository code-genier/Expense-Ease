import 'package:flutter/material.dart';

class HeadingTile extends StatelessWidget {
  final String data;

  const HeadingTile({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          Text(
              data,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white38,
            ),
          ),
        ],
      ),
    );
  }
}
