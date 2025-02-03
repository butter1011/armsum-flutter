import 'package:flutter/material.dart';

class EnterUrlWidget extends StatefulWidget {
  final Function(String) onFetchArticle;

  const EnterUrlWidget({super.key, required this.onFetchArticle});

  @override
  State<EnterUrlWidget> createState() => _EnterUrlWidgetState();
}

class _EnterUrlWidgetState extends State<EnterUrlWidget> {
  final TextEditingController urlController = TextEditingController();
  String url = "";

  @override
  void dispose() {
    urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;
    final primaryColor = Theme.of(context).primaryColor;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: primaryColor,
          )),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.insert_link,
            color: Colors.black,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              onChanged: (value) {
                setState(() {
                  url = value;
                });
              },
              controller: urlController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                hintText: 'Տեղադրեք հոդվածի հղումը',
                hintStyle: textTheme.displaySmall,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
              textAlign: TextAlign.start,
              style: textTheme.bodySmall,
            ),
          ),
          InkWell(
            onTap: () {
              widget.onFetchArticle(urlController.text);
            },
            child: Container(
              height: 35,
              width: 40,
              decoration: BoxDecoration(
                border: Border.all(
                  color: textTheme.bodyLarge?.color ?? Colors.white,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.arrow_forward,
                color: textTheme.bodyLarge?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
