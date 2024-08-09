import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(
    MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse(
        'https://ws.jakarta.go.id/gateway/DataPortalSatuDataJakarta/1.0/satudata?kategori=dataset&tipe=detail&url=jumlah-usaha-jasa-perjalanan-wisata-pariwisata-yang-memiliki-perizinan'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: FutureBuilder<List<User>>(
        future: fetchUsers(),
        builder: (context, snapshot) {
          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user.periode),
                subtitle: Text(user.nomor),
              );
            },
          );
        },
      ),
    );
  }
}

class User {
  final String periode;
  final String nomor;

  User({required this.periode, required this.nomor});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      periode: json['periode_data'],
      nomor: json['nomor'],
    );
  }
}
