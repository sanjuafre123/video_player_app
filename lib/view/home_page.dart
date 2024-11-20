import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player_app/provider/video_provider.dart';
import 'package:video_player_app/view/video_page.dart';

class InstagramHomePage extends StatelessWidget {
  const InstagramHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var providerTrue = Provider.of<VideoProvider>(context);
    var providerFalse = Provider.of<VideoProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            const Text(
              'Instagram',
              style: TextStyle(
                fontFamily: 'Billabong',
                fontSize: 32,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.favorite_border, color: Colors.black),
              onPressed: () {},
              tooltip: 'Likes',
            ),
            IconButton(
              icon: const Icon(Icons.send, color: Colors.black),
              onPressed: () {},
              tooltip: 'Direct Message',
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Stories Section
          SizedBox(
            height: 109,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: NetworkImage(
                          'https://randomuser.me/api/portraits/men/${index + 1}.jpg',
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'User $index',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Posts Feed
          FutureBuilder(
            future: providerFalse.fetchApiData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: providerTrue
                        .videoPlayerModal!.categories.first.videos.length,
                    itemBuilder: (context, index) {
                      final video = providerTrue
                          .videoPlayerModal!.categories.first.videos;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // User Info
                          ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                'https://randomuser.me/api/portraits/women/${index + 1}.jpg',
                              ),
                            ),
                            title: Text(
                              'User $index',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text('Location $index'),
                            trailing: IconButton(
                              icon: const Icon(Icons.more_vert),
                              onPressed: () {},
                            ),
                          ),
                          // Post Image
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VideoPage(
                                      videoUrl: video[index].sources.first,
                                      title: video[index].title,
                                      channelName: video[index].subtitle.name,
                                      views: '10 M'),
                                ),
                              );
                            },
                            child: Image.network(
                              video[index].thumb,
                              width: double.infinity,
                              height: 400,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Interaction Icons
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.favorite_border),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(Icons.comment),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(Icons.send),
                                onPressed: () {},
                              ),
                              Spacer(),
                              IconButton(
                                icon: Icon(Icons.bookmark_border),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          // Post Details
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              'Liked by UserX and 123 others',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text('View all 10 comments'),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 4.0),
                            child: Text(
                              '2 hours ago',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {},
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 12,
              backgroundImage:
                  NetworkImage('https://randomuser.me/api/portraits/men/1.jpg'),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}

