import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:todo_app_midterm_jumawan/screens/about_me.dart';
import 'finish.dart';
import 'ongoing.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  final itemController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final userID = FirebaseAuth.instance.currentUser!.uid;


  //Add Item in the List
  void addTask() async {
    if (_formkey.currentState!.validate()) {
      final userID = FirebaseAuth.instance.currentUser!.uid;
      DateTime dateTime = DateTime.now();
      String formattedDate = DateFormat('MMMM d, yyyy, h:mm a').format(dateTime);

      Map<String, dynamic> taskMap = {
        'title': itemController.text,
        'date': formattedDate,
      };
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('users').doc(userID);
      await documentReference.update({
        'task': FieldValue.arrayUnion([taskMap]),
      });
      itemController.clear();
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
         text: 'Task Added Successfully',);
    }
  }
  //Update Tasks
  void updateTask(int index) async {
  final userID = FirebaseAuth.instance.currentUser!.uid;
  final documentReference = FirebaseFirestore.instance.collection('users').doc(userID);
  final snapshot = await documentReference.get();
  final data = snapshot.data();
  final myArray = data?['task'];
  final title = myArray[index]['title'] as String;
  TextEditingController titleController = TextEditingController(text: title);

  showDialog (
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Task'),
          content: TextField(
            controller: titleController,
          ),
          actions: <Widget>[
            TextButton (
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                final newTitle = titleController.text.trim();
                if (newTitle.isNotEmpty) {
                  myArray[index]['title'] = newTitle;
                  await documentReference.update({'task': myArray});
                  Navigator.of(context).pop();
                  QuickAlert.show(
                  context: context,
                  type: QuickAlertType.success,
                  text: 'Task Updated Successfully',
                );
                }
              },
            ),
          ],
        );
      });
}
  //Delete Task
  void deleteTask(int index) async {
    await deleteInfo(index);
    Navigator.of(context);
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: 'Task Deleted Successfully',
    );}

  //Marked Finished Task
  void finishedTask(int index) async {
    await finishedItems(index);
    Navigator.of(context);
    QuickAlert.show(
    context: context,
    type: QuickAlertType.success,
    text: 'Task Marked as Finished',
  );}
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //AppBar
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title:const Text(
            'To Do List App',
            style: TextStyle(fontSize: 20),
          ),
        ),

          //Drawer
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/logo.png'),),
                color: Colors.grey,
              ),
                child: Text('To Do List App',style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
              ),),
            ),
            
            ListTile(
              leading:const Icon(Icons.person_outline,color: Colors.black, size: 30,),
              title: const Text('Creator',style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),),
              textColor: Colors.black,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const AboutMeScreen()));
              },
            ),

            ListTile(
              leading:const Icon(Icons.exit_to_app_outlined,color: Colors.black, size: 30,),
              title: const Text('Logout',style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),),
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
      ),

          //Body
          body: Container(
            color: Colors.grey,
            padding:const EdgeInsets.all(10),
            child: Stack(
              alignment: Alignment.bottomCenter,
                children: [
                  Center(
                    child: Container(
                    child: Column(
                      children: [
                        Column(
                          children:  const[    
                          SizedBox(height: 20,),
                           Text(
                              'What\'s on your mind?',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),  
                            ),
                            SizedBox(height: 10,),
                          ],
                        ),
                  
                  Form(
                    key: _formkey,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '*Required. Please enter an item';
                          }
                        },
                        controller: itemController,
                        decoration: InputDecoration(
                          labelText: 'Input Task',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                const SizedBox(height: 15,),
                OutlinedButton(onPressed: () {
                      setState(() {
                        Navigator.of(context);
                        addTask();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                      child: const Text('Create Task', style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      ),)),
                    const SizedBox(height:15,),

                    //Stream
                    StreamBuilder<List<dynamic>>(
                      stream: getInfo(),
                      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot){
                        if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error.toString()}'));
                      }
                        if (!snapshot.hasData) {
                      return const Text('Getting your Data...');
                      }
                    List<dynamic> data = snapshot.data!;
                       
                      return Expanded(
                          child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                          int position = index + 1;
                          return SizedBox(
                            height: 75,
                            child: Card(                           
                            elevation: 30,
                            child: ListTile(
                            contentPadding:const EdgeInsets.all(8),
                            title:Text(data[index]['title'].toString(),
                            style:const  TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),),

                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(onPressed: (){setState(() {
                                updateTask(index);
                                });}, 
                                icon:const Icon(
                                  Icons.update,
                                  color: Colors.black,
                                ),
                                hoverColor: Colors.grey,
                                ),
                                IconButton(onPressed: (){
                                  setState(() {
                                    finishedTask(index);
                                  });
                                }, icon: const Icon(
                                  Icons.check,
                                  color: Colors.black,
                                ),
                                hoverColor: Colors.grey,
                                ),
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
                            foregroundColor:  const Color(0xFFF4EEE0),
                            child: Text(position.toString()),
                                ),
                              ),
                            ),
                    );
            }, ),
          );}
      ),
  ],),
)),

            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                //top: Radius.circular(30),
              ),
              child: Container(
                padding:const EdgeInsets.all(20),
                color: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

              IconButton(onPressed: (){setState(() {
                  Navigator.push(context, MaterialPageRoute(builder:(context)=>const OnGoingScreen()));
                  });
                  },
                  icon: const Icon(
                    Icons.list,
                      color: Colors.white,
                      size: 35,
                  ),
                  ),
         
              IconButton(onPressed: (){setState(() {
                    Navigator.push(context, MaterialPageRoute(builder:(context)=>const FinishedScreen()));
                    });
                    }, 
                    icon:const Icon(
                      Icons.done_all,
                        color: Colors.white,
                        size: 35,
                  ),
                  ),
                ],
              ),
            ),
          ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:const [
              Text('On-Going Tasks',style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),),
            
              Text('Finished Tasks',style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),),
            ],),
           
        ]),
        )
      ),
    );
  }
}
Stream<List<dynamic>> getInfo() async* {
    final userID = FirebaseAuth.instance.currentUser!.uid;
    yield* FirebaseFirestore.instance.collection('users').doc(userID).snapshots().map((snapshot) => snapshot.get('task'));
    }
Future<void> deleteInfo(int index) async {
    final userID = FirebaseAuth.instance.currentUser!.uid;
    final firestoreInstance = FirebaseFirestore.instance;
    final docRef = firestoreInstance.collection('users').doc(userID);
    final currentArray = (await docRef.get()).data()?['task'] as List<dynamic>;
    currentArray.removeAt(index);
    await docRef.update({'task': currentArray});
    }

Future finishedItems(int index) async {
    final userID = FirebaseAuth.instance.currentUser!.uid;
    DateTime dateTime = DateTime.now();
    String formattedDate = DateFormat('MMMM d, yyyy, h:mm a').format(dateTime);
    final documentReference =
    FirebaseFirestore.instance.collection('users').doc(userID);
    final snapshot = await documentReference.get();
    final data = snapshot.data();
    final myArray = data?['task'];
    final valueAtIndex = myArray[index]['title'];
    Map<String, dynamic> finishedMap = {
    'title': valueAtIndex,
    'date': formattedDate,
    };
    await documentReference.update({
    'finished': FieldValue.arrayUnion([finishedMap]),
    });
    deleteInfo(index);
    }