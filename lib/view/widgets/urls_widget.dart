import 'package:flutter/material.dart';

class UrlsWidget extends StatelessWidget {
  const UrlsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // final primaryColor = Theme.of(context).primaryColor;
    final textTheme = Theme.of(context).textTheme;
    final cardColor = Theme.of(context).cardColor;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: textTheme.bodyLarge?.color ?? Colors.white,
                )),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 144, 152, 161),
                  child: Icon(
                    Icons.copy,
                    color: Colors.black,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Տեղադրեք հոդվածի հղումը',
                    ),
                    style: TextStyle(
                        color: textTheme.bodyLarge?.color ?? Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
