// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_signup/Screen_view/login_page.dart';

class TudoScreen extends StatefulWidget {
  const TudoScreen({super.key});

  @override
  State<TudoScreen> createState() => _TudoScreenState();
}

class _TudoScreenState extends State<TudoScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  void updateUser(String id) {
    // Fetch existing user data
    FirebaseFirestore.instance.collection("users").doc(id).get().then((doc) {
      if (doc.exists) {
        usernameController.text = doc["username"] ?? "";
        contactController.text = doc["contact"] ?? "";
        ageController.text = doc["age"] ?? "";
      }
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text(
            'Update User Data',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(
                    color: Colors.blue, // Set your desired label color here
                  ),
                ),
                style: const TextStyle(
                  color: Colors.white, // Set your desired text color here
                ),
              ),
              TextField(
                controller: contactController,
                decoration: const InputDecoration(
                  labelText: 'Contact',
                  labelStyle: TextStyle(
                    color: Colors.blue, // Set your desired label color here
                  ),
                ),
                style: const TextStyle(
                  color: Colors.white, // Set your desired text color here
                ),
              ),
              TextField(
                controller: ageController,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  labelStyle: TextStyle(
                    color: Colors.blue, // Set your desired label color here
                  ),
                ),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final String username = usernameController.text;
                final String contact = contactController.text;
                final String age = ageController.text;

                if (username.isNotEmpty &&
                    contact.isNotEmpty &&
                    age.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(id)
                      .update({
                        "username": username,
                        "contact": contact.toString(),
                        "age": age.toString(),
                      })
                      .then((value) => print("Document successfully updated"))
                      .catchError(
                          (error) => print("Error updating document: $error"));

                  usernameController.clear();
                  contactController.clear();
                  ageController.clear();

                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 15.0),
                backgroundColor: Colors.blue.shade800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: const Text(
                "Submit",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void deleteUser(String id) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .delete()
        .then((value) => print("Document successfully deleted"))
        .catchError((error) => print("Error deleting document: $error"));
  }

  void addUser() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text(
            'Add New User',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(
                    color: Colors.blue, // Set your desired label color here
                  ),
                ),
                style: const TextStyle(
                  color: Colors.white, // Set your desired text color here
                ),
              ),
              TextField(
                controller: contactController,
                decoration: const InputDecoration(
                  labelText: 'Contact',
                  labelStyle: TextStyle(
                    color: Colors.blue, // Set your desired label color here
                  ),
                ),
                style: const TextStyle(
                  color: Colors.white, // Set your desired text color here
                ),
              ),
              TextField(
                controller: ageController,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  labelStyle: TextStyle(
                    color: Colors.blue, // Set your desired label color here
                  ),
                ),
                style: const TextStyle(
                  color: Colors.white, // Set your desired text color here
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final String username = usernameController.text;
                final String contact = contactController.text;
                final String age = ageController.text;

                if (username.isNotEmpty &&
                    contact.isNotEmpty &&
                    age.isNotEmpty) {
                  await FirebaseFirestore.instance.collection('users').add({
                    'username': username,
                    'contact': contact,
                    'age': age,
                  });

                  usernameController.clear();
                  contactController.clear();
                  ageController.clear();

                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 15.0),
                backgroundColor: Colors.blue.shade800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: const Text(
                "Submit",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> signoutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign out failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: addUser,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        child: const Icon(
          Icons.add,
          size: 30,
          color: Colors.black,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Tubo Task",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              signoutUser();
            },
          ),
        ],
        leading: GestureDetector(
          onTap: () {},
          child: const Icon(Icons.calendar_month_outlined, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 0, 128, 255),
                Color.fromARGB(255, 0, 0, 0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: StreamBuilder<QuerySnapshot>(
            stream: _usersStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Something went wrong: ${snapshot.error}'),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    'No users found',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              return ListView(
                padding: const EdgeInsets.all(8.0),
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      title: Text(
                        "Name:   " + (data['username'] ?? ""),
                        style: const TextStyle(
                          color: Color.fromARGB(255, 38, 144, 196),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "Number:  " + (data['contact']?.toString() ?? ""),
                        style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(
                                  255, 0, 0, 0), // Background color
                              borderRadius:
                                  BorderRadius.circular(8), // Rounded corners
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(255, 10, 7, 7)
                                      .withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: IconButton(
                              onPressed: () => updateUser(document.id),
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white, // Background color
                              borderRadius:
                                  BorderRadius.circular(8), // Rounded corners
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(255, 0, 0, 0)
                                      .withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: IconButton(
                              onPressed: () => deleteUser(document.id),
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}
