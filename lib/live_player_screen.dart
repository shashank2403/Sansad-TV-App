import "package:flutter/material.dart";
import "package:lecle_yoyo_player/lecle_yoyo_player.dart";

import "package:sansadtv_app/constants.dart";
import "package:sansadtv_app/search_screen.dart";
import "package:sansadtv_app/themes.dart";

class LivePlayerScreen extends StatefulWidget {
  const LivePlayerScreen({super.key, required this.livestreamUrl, required this.liveStreamTitle});

  final String livestreamUrl;
  final String liveStreamTitle;
  @override
  State<LivePlayerScreen> createState() => _LivePlayerScreenState();
}

class _LivePlayerScreenState extends State<LivePlayerScreen> {
  bool fetchStatus = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool isWideScreen = constraints.maxWidth > 1000;

              return Container(
                decoration: pageCardDecoration(),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 50.0),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: isWideScreen ? 200.0 : 20.0, vertical: 20.0),
                        child: IntrinsicWidth(
                          child: SizedBox(
                            height: 200,
                            child: YoYoPlayer(
                              aspectRatio: 25 / 9,
                              url: widget.livestreamUrl,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: fetchStatus
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        widget.liveStreamTitle,
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        width: 80,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[850],
                                        ),
                                        child: Center(
                                          child: Row(
                                            children: [
                                              const Spacer(),
                                              const Icon(
                                                Icons.circle,
                                                size: 16,
                                                color: Colors.red,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "LIVE",
                                                style: TextStyle(
                                                  color: Colors.grey[100],
                                                  fontSize: 15,
                                                ),
                                              ),
                                              const Spacer(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(aboutText),
                                ],
                              )
                            : const NetworkError(),
                      ),
                      const SizedBox(height: 450.0),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
