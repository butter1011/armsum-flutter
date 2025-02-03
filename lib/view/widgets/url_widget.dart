import 'package:flutter/material.dart';

class UrlWidget extends StatefulWidget {
  const UrlWidget({super.key, required this.article, required this.url, required this.onTap, required this.copyToClipboard});
  final String article;
  final String url;
  final VoidCallback onTap;
  final VoidCallback copyToClipboard;

  @override
  State<UrlWidget> createState() => _UrlWidgetState();
}

class _UrlWidgetState extends State<UrlWidget> {
  bool _isCopied = false;

  void _handleCopy() {
    widget.copyToClipboard();
    setState(() {
      _isCopied = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isCopied = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) { 
    final cardColor = Theme.of(context).cardColor;
    final primaryColor = Theme.of(context).primaryColor;

    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: primaryColor,
            )),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        child: Row(
          children: [
            InkWell(
              onTap: _handleCopy,
              child: CircleAvatar(
                radius: 16,
                backgroundColor: const Color.fromARGB(255, 144, 152, 161),
                child: Icon(
                  _isCopied ? Icons.check : Icons.copy,
                  color: Colors.black,
                  size: 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              widget.url,
              style: const TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}