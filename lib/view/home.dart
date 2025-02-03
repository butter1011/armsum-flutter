import 'package:armsum/controller/get_summary.dart';
import 'package:armsum/core/theme_provider.dart';
import 'package:armsum/view/widgets/err_widget.dart';
import 'package:armsum/view/widgets/loading_widget.dart';
import 'package:armsum/view/widgets/summary_widget.dart';
import 'package:armsum/view/widgets/urls_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final SummaryController _summaryController = SummaryController();
  final TextEditingController urlController = TextEditingController();
  late AnimationController _animationController;
  String url = "";
  String article = "";
  Map<String, String> summaries = {};
  bool isLoading = false;
  bool happenedError = false;
  bool showTooltip = false;
  late Animation<double> _fadeAnimation;
  String toolTipMessage = "";

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    fetchSummaries();
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  void fetchSummaries() async {
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

  Future<void> fetchSummary(String url) async {
    FocusScope.of(context).unfocus();
    if (url.isEmpty) {
      setState(() {
        print("==============object");
        showTooltip = true;
        toolTipMessage = "Please fill in this field.";
        _animationController.forward();
      });
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            showTooltip = false;
          });
          _animationController.reverse();
        }
      });
      return;
    }

    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    if (!isValidUrl) {
      setState(() {
        showTooltip = true;
        toolTipMessage = "Please enter in valid URL.";
        _animationController.forward();
      });
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            showTooltip = false;
          });
          _animationController.reverse();
        }
      });
      return;
    }

    setState(() {
      isLoading = true;
      happenedError = false;
    });

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
      fetchSummaries();

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
  }

  Future<void> initializeSummaries() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('summaries', '{}');
    setState(() {
      summaries = {};
      article = "";
    });
  }

  @override
  void dispose() {
    urlController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final dividerColor = Theme.of(context).dividerColor;
    final textTheme = Theme.of(context).textTheme;
    final cardColor = Theme.of(context).cardColor;
    final primaryColor = Theme.of(context).primaryColor;

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
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: primaryColor,
                                      
                                )),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.insert_link,
                                  color: textTheme.bodyLarge?.color,
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
                                      hintStyle: TextStyle(
                                        color: textTheme.bodyLarge?.color
                                            ?.withOpacity(0.5),
                                      ),
                                    ),
                                    style: TextStyle(
                                        color: textTheme.bodyLarge?.color),
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
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: textTheme.bodyLarge?.color,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          if (showTooltip)
                            Positioned(
                              bottom: -15,
                              left: 0,
                              right: 0,
                              child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: Center(
                                  child: Container(
                                    constraints:
                                        const BoxConstraints(maxWidth: 250),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: dividerColor,
                                      ),                                  
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 25,
                                          height: 25,
                                          decoration: BoxDecoration(
                                            color: Colors.orange[700],
                                          ),
                                          child: const Center(
                                            child: Text(
                                              "!",
                                              style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w900,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          toolTipMessage,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ...summaries.entries.map((entry) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: UrlsWidget(
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