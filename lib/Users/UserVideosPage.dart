import 'package:flutter/material.dart';
import 'package:otwo/widgets/VideoProvider.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class UserVideosPage extends StatefulWidget {
  final String stageId;
  final String classId;
  final String subjectId;
  final String? userId;

  const UserVideosPage({
    super.key,
    required this.stageId,
    required this.classId,
    required this.subjectId,
    this.userId,
  });

  @override
  _UserVideosPageState createState() => _UserVideosPageState();
}

class _UserVideosPageState extends State<UserVideosPage> {
  late YoutubePlayerController _youtubeController;

  @override
  void initState() {
    super.initState();
    // Initialize the Youtube Player Controller without an initial video ID
    _youtubeController = YoutubePlayerController(
      initialVideoId: '', // Set to empty initially
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        forceHD: true,
        enableCaption: false,
        hideControls: false,
      ),
    );

    // Fetch videos when the page is initialized
    Future.microtask(() {
      final videoProvider = Provider.of<VideoProvider>(context, listen: false);
      videoProvider.fetchVideos(widget.stageId, widget.classId, widget.subjectId);
    });
  }

  @override
  void dispose() {
    // Dispose of the Youtube Player Controller
    _youtubeController.dispose();
    super.dispose();
  }

  String getThumbnailUrl(String videoId) {
    // Returns the thumbnail URL for a given video ID
    return 'https://img.youtube.com/vi/$videoId/sddefault.jpg';
  }

  @override
  Widget build(BuildContext context) {
    final videoProvider = Provider.of<VideoProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Videos")),
      body: Column(
        children: [
          // Youtube player widget to play the video
          YoutubePlayer(
            controller: _youtubeController,
            showVideoProgressIndicator: true,
          ),
          const SizedBox(height: 30),
          Expanded(
            child: videoProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : videoProvider.videos.isEmpty
                    ? const Center(child: Text("No videos available"))
                    : ListView.builder(
                        itemCount: videoProvider.videos.length,
                        itemBuilder: (context, index) {
                          final video = videoProvider.videos[index];
                          final videoUrl = video['videoUrl'];
                          final videoId = YoutubePlayer.convertUrlToId(videoUrl) ?? '';
                          final title = video['name'];

                          return ListTile(
                            title: Text(title),
                            leading: Image.network(getThumbnailUrl(videoId)),
                            onTap: () {
                              // Load the selected video into the Youtube player
                              _youtubeController.load(videoId);
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
