class Post {
  final int id;
  final String title;
  final String author;
  final String excerpt;
  final String date;
  final String content;
  final String image;
  var sourceimage;
  var link;

  bool isSaved = false;

  Post(
      {this.content,
      this.id,
      this.title,
      this.excerpt,
      this.link,
      this.date,
      this.image,
      this.author,
      this.sourceimage});

  factory Post.fromJSON(Map<String, dynamic> json) {
    return Post(
        id: json['id'],
        title: json['title']['rendered'],
        content: json['content']['rendered'],
        link: json['link'],
        date: json['date'] != null
            ? json['date'].toString().replaceFirst('T', ' ')
            : null,
        image: json['_links']['wp:featuredmedia'] != null
            ? json['_links']['wp:featuredmedia'][0]['href']
            : null,
        excerpt: json['excerpt']['rendered'],
        sourceimage: json['_embedded']['wp:featuredmedia'] != null
            ? json['_embedded']['wp:featuredmedia'][0]['source_url']
            : null,
        author: json['author'].toString());
  }
}
