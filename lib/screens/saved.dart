import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import '../Services/dataBaseService.dart';
import 'LikedPosts.dart';
import 'homeScreen.dart';

class saved extends StatefulWidget {
  const saved({super.key});

  @override
  State<saved> createState() => _savedState();
}

class _savedState extends State<saved> {
  List<Map<String, dynamic>> SavedPosts = [];
  dataBaseService dbs = dataBaseService();
  void loadSavedPosts() async {
    List<Map<String, dynamic>> posts = await dbs.getsaves();
    setState(() {
      SavedPosts = posts;
    });
  }
  @override
  void initState() {
    super.initState();
    loadSavedPosts();
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
                      Icon(Icons.favorite,color: Colors.grey,),
                      Text(
                        'Liked',
                        style: TextStyle(
                          color: Colors.grey,
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
                      Icon(Icons.bookmark,color: Colors.deepPurple,),
                      Text(
                        'Saved',
                        style: TextStyle(
                          color: Colors.deepPurple,
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
        itemCount: SavedPosts.length,
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
                          backgroundImage: NetworkImage(SavedPosts[index]['image']),
                        ),
                        title: Text(SavedPosts[index]['title'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13
                          ),),
                        subtitle: Text(SavedPosts[index]['title'],
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
                    child: Image(image: NetworkImage(SavedPosts[index]['image']),
                      fit: BoxFit.cover,
                    )),
                ReadMoreText(
                  SavedPosts[index]['description'],
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
                            Icon(Icons.thumb_up),
                            Padding(padding: EdgeInsets.all(5)),
                            Text('Like'),
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