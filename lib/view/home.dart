import 'package:armsum/controller/get_summary.dart';
import 'package:armsum/core/theme_provider.dart';
import 'package:armsum/view/widgets/enter_url_widget.dart';
import 'package:armsum/view/widgets/err_widget.dart';
import 'package:armsum/view/widgets/loading_widget.dart';
import 'package:armsum/view/widgets/summary_widget.dart';
import 'package:armsum/view/widgets/tooltip_widget.dart';
import 'package:armsum/view/widgets/url_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
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
  String url = "";
  String article = "";
  Map<String, String> summaries = {};
  bool isLoading = false;
  bool happenedError = false;
  bool showTooltip = false;
  String toolTipMessage = "";

  @override
  void initState() {
    super.initState();
    fetchPreviousSummaries();
  }

  void fetchPreviousSummaries() async {
    final prefs = await SharedPreferences.getInstance();
    String? summariesJson = prefs.getString('summaries');
    if (summariesJson != null) {
      try {
        Map<String, dynamic> decodedJson = json.decode(summariesJson);
        Map<String, String> summariesMap =
            decodedJson.map((key, value) => MapEntry(key, value.toString()));
        setState(() {
          summaries = summariesMap;
        });
      } catch (e) {
        debugPrint("Error decoding JSON: $e");
      }
    }
  }

  Future<void> fetchArticle(String url) async {
    FocusScope.of(context).unfocus();
    if (url.isEmpty) {
      setState(() {
        showTooltip = true;
        toolTipMessage = "Please fill in this field.";
      });
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            showTooltip = false;
          });
        }
      });
      return;
    }

    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    if (!isValidUrl) {
      setState(() {
        showTooltip = true;
        toolTipMessage = "Please enter in valid URL.";
      });
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            showTooltip = false;
          });
        }
      });
      return;
    }

    setState(() {
      isLoading = true;
      happenedError = false;
    });

    try {
      Map result = await _summaryController.getSummary(url);
      if (result['success'] == true) {
        final prefs = await SharedPreferences.getInstance();
        String? existingSummaries = prefs.getString('summaries');
        Map<String, String> summariesMap = {};

        if (existingSummaries != null) {
          try {
            Map<String, dynamic> decodedJson = json.decode(existingSummaries);
            summariesMap =
                decodedJson.map((key, value) => MapEntry(key, value.toString()));
          } catch (e) {
            debugPrint("Error decoding JSON: $e");
            summariesMap = {};
          }
        }
        summariesMap[url] = result['data'];
        await prefs.setString('summaries', json.encode(summariesMap));
        fetchPreviousSummaries();

        setState(() {
          article = result['data'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          happenedError = true;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        happenedError = true;
      });
      debugPrint("Error fetching article: $e");
    }
  }

  Future<void> initializeSummaries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('summaries', '{}');
      setState(() {
        summaries = {};
        article = "";
      });
    } catch (e) {
      debugPrint("Error initializing summaries: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final dividerColor = Theme.of(context).dividerColor;
    final textTheme = Theme.of(context).textTheme;

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
                            color: dividerColor,
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
                        style: textTheme.bodyLarge,
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
                        style: textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 64),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          EnterUrlWidget(
                            onFetchArticle: fetchArticle,
                          ),
                          if (showTooltip)
                            Positioned(
                                bottom: -15,
                                left: 0,
                                right: 0,
                                child: TooltipWidget(
                                  toolTipMessage: toolTipMessage,
                                )),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ...summaries.entries.map((entry) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: UrlWidget(
                                url: entry.key,
                                article: entry.value,
                                onTap: () {
                                  setState(() {
                                    article = entry.value;
                                    happenedError = false;
                                  });
                                },
                                copyToClipboard: () {
                                  Clipboard.setData(
                                      ClipboardData(text: entry.key));
                                }),
                          )),
                      if (happenedError)
                        const ErrWidget()
                      else if (isLoading)
                        const LoadingWidget()
                      else if (article.isNotEmpty)
                        SummaryWidget(article: article)
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