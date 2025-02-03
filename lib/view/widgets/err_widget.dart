import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrWidget extends StatelessWidget {
  const ErrWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          "Դե, դա չպետք է տեղի ունենար...",
          style:  GoogleFonts.libreBaskerville(
            fontSize: 20,
            color: textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "An error occurred: Failed extracting text corpus from the page. Make sure you are trying to summarize a news article or another page with clearly defined blocks of text.",
          style: textTheme.displaySmall,
        )
      ],
    );
  }
}
