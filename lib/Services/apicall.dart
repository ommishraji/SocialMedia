import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:socialmedia/Services/dataBaseService.dart';
class apiCall{
  final String url = 'https://post-api-omega.vercel.app/api/posts?page';
  Future<List> fetch(int pageNumber) async{
    try{
    http.Response response = await http.get(Uri.parse('$url=$pageNumber'));
    if(response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Falied');
    }
  }catch(e){
      throw Exception('Failed to load Posts');
    }
    }
  
  SaveInSaves() async{
    int pageNumber = 1;
    try{
      List<dynamic> post = await fetch(pageNumber);
      dataBaseService databaseservices = dataBaseService();
      databaseservices.insertsaves({
        'title': post[0]['title'],
        'image': post[0]['image'][0],
        'description': post[0]['eventDescription'],
      });
    }
    catch(e){
      print(e);
    }
  }
  void MultipleCallToSave()async{
    dataBaseService databaseservices = dataBaseService();
    List<Map<String, dynamic>> posts = await databaseservices.getsaves();
    if(posts.length<50)
    for(int a =0; a<10; a++)
      SaveInSaves();
  }

}