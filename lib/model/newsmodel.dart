class NewsQueryModel {
  final String? newsHead;
  final String? newsDes;
  final String? newsImg ;
  final String? newsUrl;

  NewsQueryModel({this.newsHead, this.newsDes, this.newsImg, this.newsUrl});

  factory NewsQueryModel.fromMap(Map news){
    
    return NewsQueryModel(
      newsHead: news["title"],
       newsDes : news["description"],
        newsImg : news["urlToImage"],
         newsUrl : news["url"]
         );
  }
}