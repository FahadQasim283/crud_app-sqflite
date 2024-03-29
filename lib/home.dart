import 'package:flutter/material.dart';
import 'package:sqf_app/db_handler.dart';
import 'package:sqf_app/notes_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DBHelper _dbHelper = DBHelper();
  late Future<List<NotesModel>> list;
  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() async {
    list = _dbHelper.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SQL Notes"),
      ),
      body: Column(
        children: [
          const Center(child: Text("data")),
          Expanded(
            child: FutureBuilder(
              future: list,
              builder: (context, AsyncSnapshot<List<NotesModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.data!.isEmpty) {
                  return const Text("No Data");
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onDoubleTap: () {
                          _dbHelper.updateData(NotesModel(
                            id: snapshot.data![index].id!,
                            age: 24,
                            title: "hehe",
                            description: "description",
                            email: "email@gmail.com",
                          ));
                          setState(() {
                            loadData();
                          });
                        },
                        child: Dismissible(
                          background: const Card(
                              color: Colors.red, child: Icon(Icons.delete)),
                          onDismissed: (DismissDirection direction) {
                            _dbHelper.deleteData(snapshot.data![index].id!);
                            loadData();
                          },
                          key: ValueKey<int>(snapshot.data![index].id!),
                          child: Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                  child: Text(
                                      snapshot.data![index].id.toString())),
                              title:
                                  Text(snapshot.data![index].title.toString()),
                              subtitle:
                                  Text(snapshot.data![index].email.toString()),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _dbHelper
                .insertData(
                    model: const NotesModel(
                        age: 22,
                        title: "My Notes",
                        description: "ABCdasjkhks",
                        email: "xyz@gmail.com"))
                .then((value) {
              debugPrint("added........");
              setState(() {
                loadData();
              });
            }).onError((error, stackTrace) {
              debugPrint("Failed to add data $error");
            });
          },
          label: const Text("Add Data")),
    );
  }
}
