import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:socialmedia/screens/homeScreen.dart';
import 'package:socialmedia/screens/saved.dart';

import '../Services/dataBaseService.dart';

class Likedposts extends StatefulWidget {
  Likedposts({super.key});

  @override
  State<Likedposts> createState() => _LikedpostsState();
}

class _LikedpostsState extends State<Likedposts> {
  List<Map<String, dynamic>> likedPosts = [];
  dataBaseService dbs = dataBaseService();
  @override
  void initState() {
    super.initState();
    loadLikedPosts();
  }

  void loadLikedPosts() async {
    List<Map<String, dynamic>> posts = await dbs.getLikedPosts();
    setState(() {
      likedPosts = posts;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 5,
        backgroundColor: Colors.white,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.menu),
            Text('DEMO APP',
              style: TextStyle(
                  fontWeight: FontWeight.bold
              ),),
            Icon(Icons.notification_add_outlined),
          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(child: body()),
          bottombar(context)
        ],
      ),

    );
  }

  Container bottombar(BuildContext context) {
    return Container(
          color: Colors.black,
          width: MediaQuery.of(context).size.width*1,
          height: MediaQuery.of(context).size.height*.06,
          child: Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context)=>const homeScreen()));
                  },
                  child: const Column(
                    children: [
                      Icon(Icons.home,color: Colors.grey,),
                      Text(
                        'Feed',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context)=>Likedposts()));
                  },
                  child: const Column(
                    children: [
                      Icon(Icons.favorite,color: Colors.redAccent,),
                      Text(
                        'Liked',
                        style: TextStyle(
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ),
                const Column(
                  children: [
                    Icon(Icons.people,color: Colors.grey,),
                    Text(
                      'Community',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context)=>const saved()));
                  },
                  child: const Column(
                    children: [
                      Icon(Icons.bookmark_border,color: Colors.grey,),
                      Text(
                        'Saved',
                        style: TextStyle(
                          color: Colors.grey,
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

  ListView body() {
    return ListView.builder(
        itemCount: likedPosts.length,
        itemBuilder: (context, index){
          return Container(
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(likedPosts[index]['image']),
                        ),
                        title: Text(likedPosts[index]['title'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13
                          ),),
                        subtitle: Text(likedPosts[index]['title'],
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 11
                          ),),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.more_horiz),
                    ),
                  ],
                ),
                SizedBox(
                    height: MediaQuery.sizeOf(context).width*1,
                    width: MediaQuery.sizeOf(context).width*1,
                    child: Image(image: NetworkImage(likedPosts[index]['image']),
                      fit: BoxFit.cover,
                    )),
                ReadMoreText(
                  likedPosts[index]['description'],
                  trimMode: TrimMode.Line,
                  trimLines: 2,
                  colorClickableText: Colors.grey,
                  trimCollapsedText: 'Show more',
                  trimExpandedText: 'Show less',
                  moreStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const Divider(
                  color: Colors.grey,
                  height: 20,
                  thickness: 0.5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            // likedPosts[index]['likes']++;
                          });
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.thumb_up,
                              color: Colors.blue,
                            ),
                            Padding(padding: EdgeInsets.all(5)),
                            Text('Liked'),
                          ],
                        ),
                      ),
                      const Row(
                        children: [
                          Icon(Icons.messenger_outline_sharp),
                          Padding(padding: EdgeInsets.all(5)),
                          Text('Comments',
                            softWrap: false,
                         ),
                        ],
                      ),
                      const Row(
                        children: [
                          Icon(Icons.screen_share_outlined),
                          Padding(padding: EdgeInsets.all(5)),
                          Text('Share'),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 10,
                  width: MediaQuery.of(context).size.width*1,
                  color: Colors.grey.shade300,
                )

              ],
            ),
          );
        });
  }
}