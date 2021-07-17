import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_database_new/user_model.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

const loginBoxName = "loginBox";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<UserModel>(loginBoxName);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController collegeController = TextEditingController();

  late Box<UserModel> userBox;
  bool isLoggedIn = false;
  String? name = '';
  String? college = '';
  // String? User;

  @override
  void initState() {
    super.initState();
    userBox = Hive.box<UserModel>(loginBoxName);
    autoLogIn2();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   autoLogIn2();
  // }

  Future<void> autoLogIn2() async {
    UserModel? person = userBox.get('user1');

    if (person?.name != null) {
      setState(() {
        isLoggedIn = true;
        name = person?.name;
        college = person?.college;
      });
      return;
    }
  }

  Future<Null> logout2() async {
    userBox.delete('user1');
    setState(() {
      name = '';
      college = '';
      isLoggedIn = false;
    });
  }

  Future<Null> loginUser2() async {
    // var box = Hive.box('loginBox');

    // var person = UserModel(id: '');

    // UserModel? person = userBox.put('user1', 'tinku');
    // box.add(person);

    setState(() {
      // UserModel user1 = UserModel()..id = nameController.text;
      UserModel user1 = UserModel();
      user1.name = nameController.text;
      user1.college = collegeController.text;

      userBox.put("user1", user1);
      isLoggedIn = true;
      name = nameController.text;
      college = collegeController.text;
      // print(id.getAt(0));
    });

    nameController.clear();
    collegeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auto Login Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            !isLoggedIn
                ? Column(
                    children: [
                      TextField(
                          textAlign: TextAlign.center,
                          controller: nameController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Please enter your name')),
                      TextField(
                          textAlign: TextAlign.center,
                          controller: nameController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Please enter your college'))
                    ],
                  )
                : Column(
                    children: [
                      Text('You are logged in as $name'),
                      Text('You are logged in as $college'),
                    ],
                  ),
            SizedBox(height: 10.0),
            RaisedButton(
              onPressed: () {
                isLoggedIn ? logout2() : loginUser2();
              },
              child: isLoggedIn ? Text('Logout') : Text('Login'),
            )
          ],
        ),
      ),
    );
  }
}
