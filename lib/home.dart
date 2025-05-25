import 'package:flutter/material.dart';
import 'package:flutter_animations/app_database.dart';
import 'package:flutter_animations/note_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late AppDataBase myDB;
  List<NoteModel> arrNotes = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myDB = AppDataBase.db;
    getNotes();
  }

  void addNote({required String title, required String desc}) async {
    bool check = await myDB.addNote(NoteModel(title: title, desc: desc));
    if (check) {
      arrNotes = await myDB.fetchAllNotes();
      setState(() {});
    }
  }

  void getNotes() async {
    arrNotes = await myDB.fetchAllNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Database"),
      ),
      body: ListView.builder(
          itemCount: arrNotes.length,
          itemBuilder: (_, index) {
            return InkWell(
              onTap: (){
                titleController.text = arrNotes[index].title;
                descController.text = arrNotes[index].desc;
                showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  height: 400,
                  child: Column(
                    children: [
                      Text(
                        "Update Note",
                        style: TextStyle(fontSize: 21),
                      ),
                      TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                            hintText: 'Enter Title',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(21.0))),
                      ),
                      TextField(
                        controller: descController,
                        decoration: InputDecoration(
                            hintText: 'Enter Desc',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(21.0))),
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            var title = titleController.text.toString();
                            var desc = descController.text.toString();
                            await myDB.updateNote(NoteModel(title: arrNotes[index].title, desc: arrNotes[index].desc));
                            getNotes();
                            titleController.clear();
                            descController.clear();
                            Navigator.pop(context);
                          },
                          child: Text('Update'))
                    ],
                  ),
                );
              });
              },
              child: ListTile(
                title: Text(arrNotes[index].title),
                subtitle: Text(arrNotes[index].desc),
                trailing: InkWell(
                  onTap: () async{
                   await myDB.deleteNote(arrNotes[index].note_id!);
                   getNotes();
                  },
                  child: const Icon(Icons.delete),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  height: 400,
                  child: Column(
                    children: [
                      Text(
                        "Add Note",
                        style: TextStyle(fontSize: 21),
                      ),
                      TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                            hintText: 'Enter Title',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(21.0))),
                      ),
                      TextField(
                        controller: descController,
                        decoration: InputDecoration(
                            hintText: 'Enter Desc',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(21.0))),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            var title = titleController.text.toString();
                            var desc = descController.text.toString();
                            addNote(title: title, desc: desc);
                            titleController.clear();
                            descController.clear();
                            Navigator.pop(context);
                          },
                          child: Text('Add'))
                    ],
                  ),
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
