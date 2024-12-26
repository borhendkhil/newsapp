import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app_tekup/article.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:url_launcher/url_launcher.dart';

class NewsProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Article> _news = [];
  final List<dynamic> _favourites = [];
  final List<dynamic> _history = [];
  final List<dynamic> _dbfavourites = [];
  final List<dynamic> _dbhistory = [];
  String _category = 'business';
  String _language = 'en';

  List<dynamic> get news => _news;
  List<dynamic> get favourites => _favourites;
  List<dynamic> get history => _history;
  List<dynamic> get dbfavourites => _dbfavourites;
  List<dynamic> get dbhistory => _dbhistory;
  String get category => _category;
  String get language => _language;

  bool isFavourite(article) => _dbfavourites.contains(article);

  // void toggleFavourite(article) {
  //   if (isFavourite(article)) {
  //     _favourites.remove(article);
  //   } else {
  //     _favourites.add(article);
  //     print('added fav');
  //   }
  //   notifyListeners();
  // }
  void toggleFavourite(article) async {
    final user = _auth.currentUser;
    if (user == null) return;

    if (isFavourite(article)) {
      _dbfavourites.remove(article);
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favourites')
          .doc(article.title)
          .delete();
    } else {
      _dbfavourites.add(article);
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favourites')
          .doc(article.title)
          .set(article.toJson());
      print('added fav');
    }
    notifyListeners();
  }

  // void viewArticle(article) {
  //   _history.add(article);
  //   final Uri articleUri = Uri.parse(article.url);
  //   launchURL(articleUri);
  //   notifyListeners();
  // }
  void viewArticle(article) async {
    final user = _auth.currentUser;
    if (user == null) return;

    _dbhistory.add(article);
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('history')
        .doc(article.title)
        .set(article.toJson());
    final Uri articleUri = Uri.parse(article.url);
    launchURL(articleUri);
    notifyListeners();
  }

  void launchURL(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> fetchFavourites() async {
    final user = _auth.currentUser;
    if (user == null) return;
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favourites')
          .get();
      _dbfavourites.clear();
      for (var doc in snapshot.docs) {
        _dbfavourites.add(Article.fromJson(doc.data()));
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void setCategory(String category) {
    _category = category;
    fetchNews();
  }

  void setLanguage(String language) {
    _language = language;
    fetchNews();
  }

  Future<void> fetchNews() async {
    final dio = Dio();
    final response = await dio.get(
        'https://newsapi.org/v2/top-headlines?country=us&category=$_category&language=$_language&apiKey=e605cbd3ea5b4388947285955f91a1e5');
    if (response.statusCode == 200) {
      final articlesJSON = response.data['articles'] as List;
      _news = articlesJSON.map((article) => Article.fromJson(article)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load news');
    }
  }

  Future<void> fetchHistory() async {
    final user = _auth.currentUser;
    if (user == null) return;
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('history')
          .get();
      _dbhistory.clear();
      for (var doc in snapshot.docs) {
        _dbhistory.add(Article.fromJson(doc.data()));
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}

class AuthenticationProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> login(
      String email, String password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      print(e);
    }
  }

  Future<void> signup(
      String email, String password, BuildContext context) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      print(e);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }
}
