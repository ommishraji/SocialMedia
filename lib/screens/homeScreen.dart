import 'package:flutter/material.dart';
import 'package:socialmedia/Services/apicall.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:readmore/readmore.dart';
import 'package:socialmedia/Services/dataBaseService.dart';
import 'package:socialmedia/screens/LikedPosts.dart';
import 'package:socialmedia/screens/saved.dart';
ScrollController controller = ScrollController();
class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  apiCall apicall = apiCall();
  List<dynamic> posts = [];
  int currentPage = 0;
  bool isLoading = false;
  final dataBaseService databaseService = dataBaseService();


  fetchPost() async{
    setState(() {
      isLoading = true;
    });
    try{
    List<dynamic> newpost = await apicall.fetch(currentPage);
    setState(() {
      posts.addAll(newpost);
    });
    }catch(e){
      dataBaseService databaseservices = dataBaseService();
      List<Map<String, dynamic>> posts = await databaseservices.getsaves();
      if(posts.isNotEmpty) {
        Navigator.push(context,
        MaterialPageRoute(builder: (context) => const saved()));
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
    finally{
      setState(() {
        isLoading = false;
      });
    }


  }
  @override
  void initState(){
    super.initState();
    fetchPost();
    controller.addListener(onScroll);
  }

  void onScroll(){
    if(controller.position.pixels == controller.position.maxScrollExtent) {
      fetchPost();
    }
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
          Expanded(
            child: ModalProgressHUD(
                inAsyncCall: isLoading,
                child: GeneratePosts(posts: posts)),
          ),
          bottomnavigationbar(context)
        ],
      ),
    );
  }

  Container bottomnavigationbar(BuildContext context) {
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
                      Icon(Icons.home,color: Colors.deepPurple,),
                      Text(
                        'Feed',
                        style: TextStyle(
                          color: Colors.deepPurple,
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
}



class GeneratePosts extends StatefulWidget {
  const GeneratePosts({
    super.key,
    required this.posts,
  });

  final List posts;

  @override
  State<GeneratePosts> createState() => _GeneratePostsState();
}

class _GeneratePostsState extends State<GeneratePosts> {
  final dataBaseService databaseService = dataBaseService();
  void likePost(dynamic post) async {
    await databaseService.insertLikedPost({
      'title': post['title'],
      'image': post['image'][0],
      'description': post['eventDescription'],
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to liked posts')));
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        controller: controller,
          itemCount: widget.posts.length,
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
                            backgroundImage: NetworkImage(widget.posts[index]['image'][0]),
                          ),
                          title: Text(widget.posts[index]['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13
                          ),),
                          subtitle: Text(widget.posts[index]['title'],
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
                      child: Image(image: NetworkImage(widget.posts[index]['image'][0]),
                        fit: BoxFit.cover,
                      )),
                  ReadMoreText(
                    widget.posts[index]['eventDescription'],
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
                              widget.posts[index]['likes']++;
                              likePost(widget.posts[index]);
                            });
                          },
                          child: Row(
                            children: [
                               const Icon(Icons.thumb_up_alt_outlined),
                               const Padding(padding: EdgeInsets.all(5)),
                               Text('${widget.posts[index]['likes']} Like'),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.messenger_outline_sharp),
                            const Padding(padding: EdgeInsets.all(5)),
                            Text('${widget.posts[index]['__v']} Comment',
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
          }
      ),
    );
  }
}
