import 'package:appointment/appointmentClass.dart';
import 'package:appointment/dashboard.dart';
import 'package:appointment/databasehelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:toast/toast.dart';

class myapp4 extends StatefulWidget {

  const myapp4({Key? key}) : super(key: key);
  @override
  State<myapp4> createState() => _myapp4State();
}

class _myapp4State extends State<myapp4> {


  List<String>FromTime = ['9:30 AM','10:00 AM','10:30 AM',
    '11:00 AM','11:30 AM','12:00 PM','12:30 PM','01:00 PM',
    '01:30 PM','02:00 PM','02:30 PM','03:00 PM','03:30 PM',
    '04:00 PM','04:30 PM','05:00 PM','05:30 PM','06:00 PM',
    '06:30 PM','07:00 PM','07:30 PM','08:00 PM'];

  List<String>ToTime = ['10:00 AM','10:30 AM',
    '11:00 AM','11:30 AM','12:00 PM','12:30 PM','01:00 PM',
    '01:30 PM','02:00 PM','02:30 PM','03:00 PM','03:30 PM',
    '04:00 PM','04:30 PM','05:00 PM','05:30 PM','06:00 PM',
    '06:30 PM','07:00 PM','07:30 PM','08:00 PM','08:30 PM'];

  List<String> newfromtime=[];
  List<appointment> newtotime=[];

  String dropdownvalue = '9:30 AM';
  String dropvalue = '10:00 AM';
  late DatabaseHelper helper;
  String _fromTime = "Not set";
  String _toTime = "Not set";
  String _date = "Not set";
  int fromIndex = 0;
  List<appointment> newDetails = [];
  List<appointment> details = [];

  @override
  void initState() {
    super.initState();
    helper = DatabaseHelper.instance;
    refreshlist();
    selectdate();
  }


  refreshlist() async {
    newDetails = await helper.queryAllRows();
    setState(() {
      newDetails.forEach((element) {
        print("new Details value : ${element}");
      });
      details = newDetails;
      details.forEach((element) {
        newfromtime.add(element.fromTime!);
      });

      newfromtime=FromTime.where((element) => !newfromtime.contains(element)).toList();
      dropdownvalue=newfromtime[0];
      print(newfromtime);

    });
      for(int i=0; i< ToTime.length;i++)
        {
          int int1= FromTime.indexOf(ToTime[i].toString());
          print('${int1}');
        }
  }
  TextEditingController personname=TextEditingController();
  TextEditingController email=TextEditingController();
  TextEditingController description=TextEditingController();
  selectdate()
  {
    print('${_date}');
  }
  /*void finddateUsingIndexWhere(time,
      String FromTime) {
    // Find the index of person. If not found, index = -1
    final index = time.indexWhere((element) =>
    element.name == FromTime);
    if (index >= 0) {
      print('Using indexWhere: ${time[index]}');
    }
    print('------------');
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Appointment latter',),),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: personname,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Person Name',
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'E-mail',
              ),
            ),
          ),
            Container(
            child: ElevatedButton(
              onPressed: () {
              DatePicker.showDatePicker(context,theme:DatePickerTheme(
                containerHeight: 210.0,
              ),
                showTitleActions: true,
                minTime: DateTime(2000,1,1),
                maxTime: DateTime(2022,12,31),
                  onConfirm: (date){
                   // print('confirm $date');
                    _date ='${date.year}-${date.month}-${date.day}';
                    setState(() {});
                  },currentTime: DateTime.now(), locale: LocaleType.en);
              },
              child: Container(
                         alignment: Alignment.center,
                         height: 50.0,
                         child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Icon(Icons.date_range, size: 18.0, color: Colors.teal,),
                                      Text(" $_date",style: TextStyle(color: Colors.black54,fontSize: 18.0),),
                                    ],),
                                ),
                              ],),
                            Text("Change",style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold,fontSize: 18.0),),
                          ],
                         ),
                    color: Colors.white,
              ),
              ),
            ),
            Row(
                mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                children: [
                  Text('From Time:'),
                  DropdownButton(
                    value: dropdownvalue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: newfromtime.map((String FromTime) {
                        return DropdownMenuItem(
                          value: FromTime,
                          child: Text(FromTime),
                        );

                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        print("newValue-----------$newValue");
                        fromIndex = FromTime.indexOf(newValue.toString());
                        print("newValue index-----------$fromIndex");
                        dropdownvalue = newValue!;
                      });
                    },
                  ),
                ],
              ),
               Row(
                mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                children: [
                  Text('To Time'),
                  DropdownButton(
                    value: dropvalue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: ToTime.map((String toTime) {
                      int a = toTime.indexOf(toTime);
                      print("to time index------${a}");
                      print("from time index------${fromIndex}");
                      if (ToTime.indexOf(toTime) < fromIndex) {
                        return DropdownMenuItem(
                          value: toTime,
                          child: Text(toTime),
                         // onTap: () => null,
                          // enabled: false,
                        );
                      }
                      return DropdownMenuItem(
                        value: toTime,
                        child: Text(toTime)
                      );
                    }).toList(),
                      onChanged: (String? newValue) {
                       setState(() {
                         dropvalue = newValue!;
                     });
                     },
                  ),
                ],
              ),
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: description,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
              ),
            ),

          ),
          Row(
            children: [
              TextButton(
                child:  Text('Submit', style: TextStyle(fontSize: 20),),
                onPressed: () {
                  print(personname.text);
                  print(email.text);
                  print(description.text);
                  print(_date.toString());
                  print(dropdownvalue.toString());
                  print(dropvalue.toString());


                  var newApptDetails = appointment(
                    name : personname.text,
                    date : _date.toString(),
                    email: email.text,
                    fromTime: dropdownvalue,
                    toTime: dropvalue,
                    description: description.text
                  );
                  print(selectdate());
                  helper.insertAppointment(newApptDetails).then((value) {
                    if (value == true)
                    {
                      Toast.show("Your Appointment created successfully !", duration: Toast.lengthLong, gravity:  Toast.bottom);
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return  myapp3();
                      },));
                    } else
                    {
                      Toast.show("Your Appointment not created successfully !", duration: Toast.lengthLong, gravity:  Toast.bottom);
                    }
                  });
                  //signup screen
                },
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ],
      ),
    );

  }
}
