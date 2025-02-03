import 'package:flutter/material.dart';

class UrlsWidget extends StatelessWidget {
  const UrlsWidget({super.key, required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    // final primaryColor = Theme.of(context).primaryColor;
    final textTheme = Theme.of(context).textTheme;
    final cardColor = Theme.of(context).cardColor;

    return Container(
      decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: textTheme.bodyLarge?.color ?? Colors.white,
          )),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: Color.fromARGB(255, 144, 152, 161),
            child: Icon(
              Icons.copy,
              color: Colors.black,
              size: 12,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            url,
            style: const TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
