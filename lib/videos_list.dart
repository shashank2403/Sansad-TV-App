import 'package:flutter/material.dart';
import 'package:sansadtv_app/player_screen.dart';

class VideosList extends StatefulWidget {
  const VideosList({
    super.key,
    required this.videoID,
    required this.videoThumbnailUrl,
    required this.videoTitle,
    required this.videoDate,
  });

  final List<String> videoID;
  final List<String> videoThumbnailUrl;
  final List<String> videoTitle;
  final List<String> videoDate;

  @override
  State<VideosList> createState() => _VideosListState();
}

class _VideosListState extends State<VideosList> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 1000) {
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.videoID.length,
            itemBuilder: (context, index) {
              return VideoCard(
                videoID: widget.videoID[index],
                videoThumbnailUrl: widget.videoThumbnailUrl[index],
                videoTitle: widget.videoTitle[index],
                videoDate: widget.videoDate[index],
              );
            },
          );
        } else {
          return SizedBox(
            height: 260,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 3.0,
                    ),
                    child: ScrollableVideoCard(
                      videoID: widget.videoID[index],
                      videoThumbnailUrl: widget.videoThumbnailUrl[index],
                      videoTitle: widget.videoTitle[index],
                      videoDate: widget.videoDate[index],
                    ),
                  );
                },
                itemCount: widget.videoID.length,
                scrollDirection: Axis.horizontal,
              ),
            ),
          );
        }
      },
    );
  }
}

class LivestreamCarousel extends StatefulWidget {
  const LivestreamCarousel({
    super.key,
    required this.livestreamID,
    required this.livestreamThumbnailUrl,
    required this.livestreamTitle,
  });

  final List<String> livestreamID;
  final List<String> livestreamThumbnailUrl;
  final List<String> livestreamTitle;

  @override
  LivestreamCarouselState createState() => LivestreamCarouselState();
}

class LivestreamCarouselState extends State<LivestreamCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 1000) {
          return _buildPageView();
        } else {
          return _buildScrollableRow();
        }
      },
    );
  }

  Widget _buildPageView() {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.livestreamID.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayerScreen(videoID: widget.livestreamID[index]),
                    ),
                  );
                },
                child: VideoCard(
                  videoID: widget.livestreamID[index],
                  videoThumbnailUrl: widget.livestreamThumbnailUrl[index],
                  videoTitle: widget.livestreamTitle[index],
                ),
              );
            },
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
        ),
        const SizedBox(height: 8),
        _buildDotsIndicator(),
      ],
    );
  }

  Widget _buildScrollableRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.livestreamID.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlayerScreen(videoID: widget.livestreamID[index]),
                ),
              );
            },
            child: ScrollableVideoCard(videoID: widget.livestreamID[index], videoThumbnailUrl: widget.livestreamThumbnailUrl[index], videoTitle: widget.livestreamTitle[index]),
          );
        },
      ),
    );
  }

  Widget _buildDotsIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.livestreamID.length,
        (index) {
          return Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentPage == index ? Theme.of(context).primaryColor : Colors.grey,
            ),
          );
        },
      ),
    );
  }
}

class ScrollableVideoCard extends StatelessWidget {
  const ScrollableVideoCard({super.key, required this.videoID, required this.videoThumbnailUrl, required this.videoTitle, this.videoDate = ""});

  final String videoID;
  final String videoThumbnailUrl;
  final String videoTitle;
  final String videoDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
      child: Container(
        width: 400,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(videoThumbnailUrl),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              blurRadius: 6.0,
            )
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 12,
              right: 17,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    videoTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  videoDate != ""
                      ? Text(
                          videoDate,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            height: 1.2,
                          ),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoCard extends StatelessWidget {
  const VideoCard({
    super.key,
    required this.videoID,
    required this.videoThumbnailUrl,
    required this.videoTitle,
    this.videoDate = "",
  });

  final String videoID;
  final String videoThumbnailUrl;
  final String videoTitle;
  final String videoDate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayerScreen(videoID: videoID),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 3.0,
          horizontal: 10.0,
        ),
        child: Card(
          child: Container(
            height: 220,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(videoThumbnailUrl),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 6.0,
                )
              ],
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 12,
                  right: 17,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        videoTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      videoDate != ""
                          ? Text(
                              videoDate,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                height: 1.2,
                              ),
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            )
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
