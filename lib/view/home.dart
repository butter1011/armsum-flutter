import 'package:armsum/core/theme_provider.dart';
import 'package:armsum/view/widgets/summary_widget.dart';
import 'package:armsum/view/widgets/urls_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final primaryColor = Theme.of(context).primaryColor;
    final textTheme = Theme.of(context).textTheme;
    final cardColor = Theme.of(context).cardColor;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                themeProvider.isDarkMode
                    ? 'assets/images/background_dark.png'
                    : 'assets/images/background_light.png',
              ),
              fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: SvgPicture.asset(
                        'assets/images/armsum_logo.svg',
                        semanticsLabel: 'Armsum Logo',
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          height: 34,
                          width: 120,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Text(
                              "Instagram",
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            themeProvider.isDarkMode
                                ? Icons.brightness_4
                                : Icons.brightness_7,
                            color: Colors.amber,
                          ),
                          onPressed: () {
                            themeProvider.toggleTheme();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Main Content
              Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 28.0, horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Ամփոփել հոդվածները',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.libreBaskerville(
                            fontSize: 44,
                            fontWeight: FontWeight.bold,
                            color: textTheme.bodyLarge?.color,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'ArmSum',
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            Text(
                              '-ի հետ',
                              style: TextStyle(
                                fontSize: 44,
                                fontWeight: FontWeight.bold,
                                color: textTheme.bodyLarge?.color,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Պարզեցրեք ձեր ընթերցումը ArmSum-ի միջոցով՝ հոդվածների ամփոփիչ, որը երկար հոդվածները վերածում է պարզ և հակիրճ ամփոփումների ձեր հրամով:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 64),
                        // Search Bar
                        Container(
                          decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: textTheme.bodyLarge?.color ?? Colors.white,
                              )),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.insert_link,
                                color: Colors.black,
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
                                      color: textTheme.bodyLarge?.color ??
                                          Colors.white),
                                ),
                              ),
                              Container(
                                height: 35,
                                width: 40,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: textTheme.bodyLarge?.color ??
                                        Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.arrow_forward),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        const UrlsWidget(),
                  
                        SummaryWidget(),
                        
                      ],
                    ),
                  ),
                ),
              
            ],
          ),
        ),
      ),
    );
  }
}
