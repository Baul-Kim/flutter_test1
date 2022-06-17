import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

void main() {
  runApp( MaterialApp(
    home : MyApp()
  ));
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  addOn(){
    setState((){
      a++;
    });
  }

  addname(a) {
    setState((){
      name.add(a);
    });
  }

  getPermission() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      print('허락됨');
      var contacts = await ContactsService.getContacts();
      setState(() {
        name = contacts;
      });
      // print(contacts[0].familyName);
      // 연락처에 추가하는 함수
      // var newPerson = Contact();
      // newPerson.givenName = '민수';
      // newPerson.familyName = '김';
      // ContactsService.addContact(newPerson);

    } else if (status.isDenied) {
      print('거절됨');
      Permission.contacts.request();
    }
  }

  List<Contact> name = [];
  var a = 3;
  var like = [0,0,0];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Text('+'),
          onPressed: (){
            showDialog(context: context, builder: (context){
              return DialogUI(state: a,addOn: addOn,name: name,addname: addname);
            });
          },
        ),
        bottomNavigationBar: BottomSty(),
        appBar: AppBar(title: Text('Wave.ai   '+a.toString()),leading: Icon(Icons.list),
        actions: [
          IconButton(onPressed: (){ getPermission();}, icon: Icon(Icons.contacts))
        ],
        ),
        body: ListView.builder(
          itemCount: name.length,
            itemBuilder: (context, i){
            print('컨텐드1:$context');
            return ListTile(
              leading: Icon(Icons.account_circle),
              title: Text(name[i].givenName ?? '이름없음'),
            );
            }
        ),
            );



  }
}

// 유저데이터 리스트 커스텀 위젯
class UserData extends StatelessWidget {
  const UserData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Icon(Icons.account_circle, color: Colors.black,),
          Text('홍길동1')
        ],
      ),
    );
  }
}

// BottomAppBar 커스텀 위젯
class BottomSty extends StatelessWidget {
  const BottomSty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.phone),
            Icon(Icons.message),
            Icon(Icons.contact_page),
          ],
        ),
      ),
    );
  }
}

class DialogUI extends StatelessWidget {
  DialogUI({Key? key,this.state,this.addOn,this.name,this.addname}) : super(key: key);
  var state;
  var addOn;
  var name;
  var addname;
  var inputData = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 300,
        height: 300,
        child: Column(
          children: [
            TextField(controller: inputData,),
            TextButton(
                onPressed: (){
                  var newPerson = Contact();
                  newPerson.givenName = inputData.text;
                  ContactsService.addContact(newPerson);
                  addname(newPerson);
                  Navigator.pop(context);
                },
                child: Text('확인')
            ),
            TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text('취소')
            ),
          ],
        ),
      ),
    );
  }
}


