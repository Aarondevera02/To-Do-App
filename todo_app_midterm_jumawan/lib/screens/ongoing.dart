import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class OnGoingScreen extends StatefulWidget {
  const OnGoingScreen({super.key});

  @override
  State<OnGoingScreen> createState() => _OnGoingScreenState();
}

class _OnGoingScreenState extends State<OnGoingScreen> {
  final userID = FirebaseAuth.instance.currentUser!.uid;

  //Delete Task
  void deleteTask(int index) async {
    await deleteInfo(index);
    Navigator.of(context);
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: 'Task Deleted Successfully',
    );}

@override
Widget build(BuildContext context) {
  return SafeArea(
      child: Scaffold(
      //Appbar
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title:const Text('Ongoing Task\'s',style: TextStyle(
        fontSize: 20,
      ),
      ),),
      //Body
      body: Container(
        color: Colors.grey,
        padding:const EdgeInsets.all(10),
        child: StreamBuilder<List<dynamic>>(
        stream: getInfo(),
        builder:
        (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error.toString()}'));
        }
        if (!snapshot.hasData) {
        return const Center(child: CircularProgressIndicator());
        }
        List<dynamic> data = snapshot.data!;
        return Column(
        children: [
        const SizedBox(
        height: 20,
        ),

        Expanded(
        child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
        int position = index + 1;
        return SizedBox(
        height: 75,
        child: Card(
        elevation: 30,
        child: ListTile(
          title:
          Text(data[index]['title'].toString(),
          style:const  TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          ),),
          subtitle: Text ("Started: ${data[index]['date']}",style:const TextStyle(
            fontSize: 15
          ),),

          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(onPressed: (){setState(() {
                deleteTask(index);
              });}, 
              icon:const Icon(
                Icons.delete,
                color: Colors.black,
              ),
              hoverColor: Colors.grey,
              )
            ],
          ),
          leading: CircleAvatar(
            backgroundColor: Colors.black,
            foregroundColor:const Color(0xFFF4EEE0),
            child: Text(position.toString()),
      ),
      ),
      ),
      );
      },
    ),
    ),
    ],
    );
    },
    ),
    ),
  ),
);
}
}

  Stream<List<dynamic>> getInfo() async* {
    final userID = FirebaseAuth.instance.currentUser!.uid;
    yield* FirebaseFirestore.instance
    .collection('users')
    .doc(userID)
    .snapshots()
    .map((snapshot) => snapshot.get('task'));
    }

  Future<void> deleteInfo(int index) async {
    final userID = FirebaseAuth.instance.currentUser!.uid;
    final firestoreInstance = FirebaseFirestore.instance;
    final docRef = firestoreInstance.collection('users').doc(userID);
    final currentArray = (await docRef.get()).data()?['task'] as List<dynamic>;
    currentArray.removeAt(index);
    await docRef.update({'task': currentArray});
    }