import 'package:flutter/material.dart';
import 'package:news_app_tekup/providers.dart';
import 'package:provider/provider.dart';

class FavouritesScreen extends StatefulWidget {
  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<NewsProvider>(context, listen: false).fetchFavourites();
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);

    return Scaffold(
      appBar: null,
      body: ListView.builder(
        itemCount: newsProvider.dbfavourites.length,
        itemBuilder: (context, index) {
          final article = newsProvider.dbfavourites[index];
          return Column(
            children: [
              Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (article.urlToImage != null)
                        Image.network(article.urlToImage),
                      SizedBox(height: 8.0),
                      Text(
                        article.title,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Published on: ${article.publishedAt}',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Published by: ${article.author}',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.favorite,
                              color: newsProvider.isFavourite(article)
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            onPressed: () =>
                                newsProvider.toggleFavourite(article),
                          ),
                          IconButton(
                            icon: Icon(Icons.open_in_new),
                            onPressed: () => newsProvider.viewArticle(article),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Divider(),
            ],
          );
        },
      ),
    );
  }
}
