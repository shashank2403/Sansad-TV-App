import 'package:flutter/material.dart';
import 'package:sansadtv_app/constants.dart';
import 'package:sansadtv_app/themes.dart';
import 'package:sansadtv_app/web_content_handler.dart';
import 'package:universal_html/html.dart' as html;

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({super.key});

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  late List<List<String>> notices;
  bool fetchStatus = true;
  @override
  void initState() {
    fetchNotices();
  }

  void fetchNotices() async {
    final html.HtmlDocument document = await fetchHTML(noticeUrl);
  }

  void extractData(String body) {
    final RegExp exp = RegExp(r'<a href="(.*?)">(.*?)<\/a><\/p><\/td><td>(.*?)<\/td>');

    final matches = exp.allMatches(body);

    matches.forEach((match) {
      final String url = match.group(1) as String;
      final String text = match.group(2) as String;
      final String date = match.group(3) as String;

      print(text);
      print(date);

      notices.add([url, text, date]);
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Center(
              child: Text(
                "Notice Board",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 8.0,
                      offset: Offset(
                        4.0,
                        4.0,
                      ),
                      color: Colors.black54,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              decoration: pageCardDecoration(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15.0,
                    ),
                    Center(
                      child: Image.asset('images/logo-sansad.png'),
                    ),
                    const SizedBox(height: 15.0),
                    Align(
                      alignment: Alignment.topLeft,
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 17.0,
                            color: Colors.black,
                            height: 2,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Launched: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: 'September 15, 2021\n'),
                            TextSpan(text: 'Country: ', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: 'India\n'),
                            TextSpan(text: 'Launguage: ', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: 'Hindi and English\n'),
                            TextSpan(text: 'Location: ', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: 'Parliament Library Building, Parliament House, New Delhi\n'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
