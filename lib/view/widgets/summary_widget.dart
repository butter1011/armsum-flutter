import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SummaryWidget extends StatelessWidget {
  const SummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cardColor = Theme.of(context).cardColor;

    return SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Հոդվածի',
                style: GoogleFonts.libreBaskerville(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(width: 4),
              Text("ամփոփում",
                  style: GoogleFonts.libreBaskerville(
                      fontSize: 20, color: Colors.blue)),
            ],
          ),
          SizedBox(height: 16),
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
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),                      
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
