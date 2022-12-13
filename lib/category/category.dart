

import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:news/model/newsmodel.dart';
import 'package:news/webview.dart';

class Category extends StatefulWidget {
  String Query;
  Category({required this.Query});
   
  
  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
   bool isLoading = true;

  List<NewsQueryModel> newsmodelist = <NewsQueryModel>[];
 
 

  TextEditingController searchController = TextEditingController();

  void getNews(String query) async {

   
    String Url ="";
    if(query == "Top News" || query == "India" ){
      Url =  
       "https://newsapi.org/v2/top-headlines?country=$query&apiKey=9bb7bf6152d147ad8ba14cd0e7452f2f";
    }else{
      Url =  
          "https://newsapi.org/v2/everything?q=in&from=2022-12-5&to=2022-12-12&sortBy=popularity&apiKey=7bc8c952b65743739636a16bb89ab480";
    
    }
    Response response = await get(Uri.parse(Url));
    Map data = jsonDecode(response.body);
    // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
    setState(() {
       data["articles"].forEach((Element) {
      NewsQueryModel newsquwryModel = NewsQueryModel();
      newsquwryModel = NewsQueryModel.fromMap(Element);
      newsmodelist.add(newsquwryModel);

      log(newsquwryModel.toString());
      setState(() {
        isLoading = false;
      });
    });
  
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNews(widget.Query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color.fromARGB(255, 13, 25, 77),
        title: const Center(child: Text("Konade News App")),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
                 Text(
                   "Headlines",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: newsmodelist.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => NewsViews(uri: newsmodelist[index].newsUrl.toString())));
                            },
                            child: Container(
                              margin:
                                  EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            newsmodelist[index].newsImg.toString(),
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                        left: 0,
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          height: 55,
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.black45.withOpacity(0),
                                                  Colors.black
                                                ]),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                newsmodelist[index]
                                                    .newsHead
                                                    .toString(),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 19,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                newsmodelist[index]
                                                    .newsDes
                                                    .toString(),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
            ],
          ),
        ),
      ) 
    );
  }
}