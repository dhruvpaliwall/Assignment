import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreen extends StatelessWidget {
  final UserCredential userCredential;

  const HomeScreen(this.userCredential, {super.key});

  Future<List<Map<String, dynamic>>> fetchData() async {
    final response =
        await http.get(Uri.parse('https://api.publicapis.org/entries'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['entries']);
    } else {
      throw Exception('Failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Welcome, ${userCredential.user?.displayName ?? 'User'}!'),
            const SizedBox(
              height: 50,
            ),
            CircleAvatar(
              backgroundImage:
                  NetworkImage(userCredential.user?.photoURL ?? ''),
              radius: 50,
            ),
            ElevatedButton(
              onPressed: () {
                fetchData().then((data) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AnimalListScreen(data)),
                  );
                });
              },
              child: const Text('Get Animal'),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimalListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> animalData;

  const AnimalListScreen(this.animalData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animal List')),
      body: ListView.builder(
        itemCount: animalData.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(animalData[index]['Category']),
            subtitle: Text(animalData[index]['Description']),
          );
        },
      ),
    );
  }
}
