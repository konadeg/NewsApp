// ignore: file_names
import 'dart:convert';
import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:news/category/category.dart';
import 'package:news/model/newsmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:news/webview.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;

  List<NewsQueryModel> newsmodelist = <NewsQueryModel>[];
  List<NewsQueryModel> neescountrymodellist = <NewsQueryModel>[];
  List newscategory =[
    "Top News",
    "Politics",
    "Helth",
    "Sports",
    "India",
    "World"
  ];

  TextEditingController searchController = TextEditingController();
  


  void getNews(String query) async {
    // ignore: non_constant_identifier_names
    String Url =
        "https://newsapi.org/v2/everything?q=$query&from=2022-12-5&to=2022-12-12&sortBy=popularity&apiKey=7bc8c952b65743739636a16bb89ab480";
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
    newsmodelist.sublist(0,5);
  
    });}

  void getNewsOfCountry() async {
    // ignore: non_constant_identifier_names
    String Url =
        "https://newsapi.org/v2/top-headlines?country=in&apiKey=7bc8c952b65743739636a16bb89ab480";
    Response response = await get(Uri.parse(Url));
    Map data = jsonDecode(response.body);
    // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
    setState(() {
      data["articles"].forEach((Element) {
      NewsQueryModel newsquwryModel = NewsQueryModel();
      newsquwryModel = NewsQueryModel.fromMap(Element);
      neescountrymodellist.add(newsquwryModel);

      log(newsquwryModel.toString());
      setState(() {
        isLoading = false;
      });
    });
    neescountrymodellist.sublist(0,5);
    });
    
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNews("india");
    getNewsOfCountry();
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
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 236, 223, 223),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if ((searchController.text).replaceAll(" ", "") == "") {
                          // ignore: avoid_print
                          print("Blank search");
                        } else {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                   Category(Query: searchController.text)   ));
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(7, 0, 10, 0),
                        child: const Icon(
                          Icons.search,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value){
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                   Category(Query: value)   ));
                        },
                        controller: searchController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search health"),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Category(Query: newscategory.length.toString()) ));
                },
                child: SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: newscategory.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 51, 23, 21),
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Text(
                            newscategory[index],
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              CarouselSlider(
                
                  options:
                      CarouselOptions(
                      
                        autoPlay: true, enlargeCenterPage: true),
                  items: neescountrymodellist.map((instants) {
                    return Builder(builder: (BuildContext context) {
                      return InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => NewsViews(uri: instants.newsUrl.toString())));
                        },
                        child: Container(
                          height: 100,
                          margin: EdgeInsets.all(5),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    instants.newsImg.toString(),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                    left: 0,
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      height: 60,
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10)),
                                          color: Colors.black),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            instants.newsHead.toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 19,
                                                fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          Text(
                                            instants.newsDes.toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
                  }).toList()),
              SizedBox(
                height: 5,
              ),
              Text(
                "Latest News",
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => NewsViews(uri: newsmodelist[index].newsUrl.toString()) ));
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
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Color> items = [
    Colors.black,
    Colors.transparent,
    Colors.blue,
    Colors.deepOrangeAccent,
    Colors.purple
  ];
}
