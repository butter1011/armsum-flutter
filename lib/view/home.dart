import 'package:armsum/controller/get_summary.dart';
import 'package:armsum/core/theme_provider.dart';
import 'package:armsum/view/widgets/loading_widget.dart';
import 'package:armsum/view/widgets/summary_widget.dart';
import 'package:armsum/view/widgets/urls_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SummaryController _summaryController = SummaryController();
  final TextEditingController urlController = TextEditingController();
  String url = "";
  String article = "";
  Map<String, String> summaries = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchSummaries();
  }

  void fetchSummaries() async {
    print("✨");
    final prefs = await SharedPreferences.getInstance();
    String? summariesJson = prefs.getString('summaries');
    print("✨✨$summariesJson");
    if (summariesJson != null) {
      print("🎎🎏🎏");
      try {
        Map<String, dynamic> decodedJson = json.decode(summariesJson);
        Map<String, String> summariesMap =
            decodedJson.map((key, value) => MapEntry(key, value.toString()));
        print("✨✨✨ ${summariesMap.length}");

        setState(() {
          summaries = summariesMap;
        });
      } catch (e) {
        print("Error decoding JSON: $e");
      }
    }
  }

  Future<void> fetchSummary(String url) async {
    setState(() {
      isLoading = true;
    });

    String result = await _summaryController.getSummary(url);
    print("This is  the summary🧨: $result");

    // Save url and article to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    String? existingSummaries = prefs.getString('summaries');
    Map<String, String> summariesMap = {};

    if (existingSummaries != null) {
      try {
        Map<String, dynamic> decodedJson = json.decode(existingSummaries);
        summariesMap =
            decodedJson.map((key, value) => MapEntry(key, value.toString()));
      } catch (e) {
        print("Error decoding JSON: $e");
        summariesMap = {};
      }
    }
    summariesMap[url] = result;
    await prefs.setString('summaries', json.encode(summariesMap));
    fetchSummaries();

    setState(() {
      article = result;
      isLoading = false;
    });
  }

  Future<void> initializeSummaries() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('summaries', '{}');
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final primaryColor = Theme.of(context).primaryColor;
    final textTheme = Theme.of(context).textTheme;
    final cardColor = Theme.of(context).cardColor;

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
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
                    InkWell(
                      onTap: () => initializeSummaries(),
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: SvgPicture.asset(
                          'assets/images/armsum_logo.svg',
                          semanticsLabel: 'Armsum Logo',
                        ),
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
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
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
                              child: TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    url = value;
                                  });
                                },
                                controller: urlController,
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
                            InkWell(
                              onTap: () {
                                fetchSummary(urlController.text);
                              },
                              child: Container(
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
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...summaries.keys.map((key) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: UrlsWidget(url: key),
                          )),
                      if (isLoading)
                        const LoadingWidget()
                      else if (article.isNotEmpty)
                        SummaryWidget(article: article)
                      else
                        const SizedBox(height: 200),
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
