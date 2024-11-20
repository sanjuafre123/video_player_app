import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:provider/provider.dart';
import '../provider/video_provider.dart';

class VideoPage extends StatefulWidget {
  final String videoUrl;
  final String title;
  final String channelName;
  final String views;

  const VideoPage({
    super.key,
    required this.videoUrl,
    required this.title,
    required this.channelName,
    required this.views,
  });

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<VideoProvider>(context, listen: false)
          .initializePlayer(widget.videoUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    var providerTrue = Provider.of<VideoProvider>(context);
    var providerFalse = Provider.of<VideoProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Video Player
            providerTrue.chewieController != null &&
                    providerTrue.videoPlayerController.value.isInitialized
                ? Column(
                    children: [
                      AspectRatio(
                        aspectRatio: providerTrue
                            .videoPlayerController.value.aspectRatio,
                        child:
                            Chewie(controller: providerTrue.chewieController!),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.title,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${widget.views} views',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                _buildIcon(Icons.favorite_border, 'Like'),
                                const SizedBox(width: 16),
                                _buildIcon(
                                    Icons.chat_bubble_outline, 'Comment'),
                                const SizedBox(width: 16),
                                _buildIcon(Icons.share_outlined, 'Share'),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Up Next Videos Section
                      Expanded(
                        child: FutureBuilder(
                          future: providerFalse.fetchApiData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return ListView.builder(
                                itemCount: 6,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      height: 100,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              // Filter out the current video from suggestions
                              final videos = providerTrue
                                  .videoPlayerModal!.categories.first.videos
                                  .where((video) =>
                                      video.sources.first != widget.videoUrl)
                                  .toList();

                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: videos.length,
                                itemBuilder: (context, index) {
                                  final video = videos[index];
                                  return ListTile(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => VideoPage(
                                            videoUrl: video.sources.first,
                                            title: video.title,
                                            channelName: video.description,
                                            views: '${index + 1}M',
                                          ),
                                        ),
                                      );
                                    },
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.network(
                                        video.thumb,
                                        height: 70,
                                        width: 120,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    title: Text(
                                      video.title,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(
                                      'Channel Name • ${index + 1}M views',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.more_vert),
                                      onPressed: () {},
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  )
                : const Center(child: CircularProgressIndicator()),

            // Overlay Header UI
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                        'https://media.licdn.com/dms/image/v2/D4D03AQGsmgcAcdDmyg/profile-displayphoto-shrink_800_800/profile-displayphoto-shrink_800_800/0/1731396901121?e=1737590400&v=beta&t=DWVW6q-PHvQaCh4twlhTDjuq1U44MQjVwphycZwDOEY'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.channelName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Follow',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.black, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
