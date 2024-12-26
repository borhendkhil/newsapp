import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:news_app_tekup/providers.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Select News Category',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              DropdownButton<String>(
                value: newsProvider.category,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    newsProvider.setCategory(newValue);
                  }
                },
                items: <String>[
                  'business',
                  'entertainment',
                  'health',
                  'science',
                  'sports',
                  'technology'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 32.0),
              Text(
                'Select Language',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              DropdownButton<String>(
                value: newsProvider.language,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    newsProvider.setLanguage(newValue);
                  }
                },
                items: <String>[
                  'en', // English
                  'es', // Spanish
                  'fr', // French
                  'de', // German
                  'it' // Italian
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
