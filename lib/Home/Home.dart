import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mppiti/Auth/Login.dart';
import 'package:mppiti/global.dart';
import 'package:mppiti/test.dart';

class MyListItem extends StatelessWidget {
  final String title;
  // final String subtitle;
  final VoidCallback onPressed;

  const MyListItem({
    required this.title,
    // required this.subtitle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: const Color(0xFF333333).withOpacity(0.1), // Border color
            width: 2.0, // Border width
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF333333).withOpacity(0.1),
              blurRadius: 54,
              spreadRadius: 0,
              offset: const Offset(10, 24),
            ),
          ],
        ),
        child: Row(
          children: [
            // ClipRRect(
            //   borderRadius: BorderRadius.all(Radius.circular(10.0)),
            //   child: Image.network(
            //     width: 80.0,
            //     height: 80.0,
            //     fit: BoxFit.cover,
            //   ),
            // ),
            const SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: Color(0xFFFE586A),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8.0),
                // Text(
                //   subtitle,
                //   style: TextStyle(
                //     fontSize: 15.0,
                //     color: Colors.grey,
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

List<dynamic> demoData = [];

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

Set<String> distinctSubjects = {};

class _HomePageState extends State<HomePage> {
  bool attempted = false;

  Future<Object> fetchResponse() async {
    final url =
        'https://maapitambrapvtitijhansi.com/app/api/quiz/${data_variable.read('trade')}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body);
        setState(() {
          demoData = responseData;
          for (var item in responseData) {
            distinctSubjects.add(item['subject']);
          }
        });

        print(distinctSubjects.toList());
      }
      return true;
    } catch (e) {
      print('Error fetching data: $e');
      return false;
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Do you want to exit the app?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: const Text('Exit'),
              ),
            ],
          ),
        )) ??
        false;
  }

  Future<Object> fetchResponse12(int index) async {
    // final url =
    //     'https://maapitambrapvtitijhansi.com/app/api/attempted?table=${data_variable.read('trade')}_${demoData[index]['name']}_result&studentID=1234';
    final url =
        'https://maapitambrapvtitijhansi.com/app/api/attempted?table=${data_variable.read('trade')}_${demoData[index]['name']}_result&studentID=${data_variable.read('ID')}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        if (response.body == 'false') {
          print('false');
          setState(() {
            attempted = false;
          });

          Modalbottomsheet(index, '');
        } else {
          setState(() {
            attempted = true;
          });

          Map<String, dynamic> responseData = jsonDecode(response.body);
          print(responseData['score']);
          Modalbottomsheet(index, responseData['score']);
        }

        return response.body == 'true';
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      return false;
    }
  }

  void Modalbottomsheet(int index, String scoree) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        // return QuizDescription(
        //   quizName: demoData[index]['name'],
        // );
        return Container(
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      demoData[index]['name'],
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                    Text(
                      'Your Short description for the selected test.',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.03,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    attempted == true
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Score : ',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey),
                              ),
                              const SizedBox(
                                width: 15.0,
                              ),
                              Text(
                                scoree,
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.07,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.green),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  print(demoData[index]['subject'] +
                                      '_' +
                                      demoData[index]['name']);
                                  // _openPdf(
                                  //     'https://maapitambrapvtitijhansi.com/app/iti/pages/Quiz/${data_variable.read('trade')}/${demoData[index]['subject']}."_".${demoData[index]['name']}.pdf'!,
                                  //     '${data_variable.read('trade')}_${demoData[index]['name']}'!);
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor:
                                      const Color(0xFFFE586A), // Text color
                                  elevation: 0, // Elevation (shadow)
                                  minimumSize:
                                      const Size(200, 45), // Width and height
                                ),
                                child: const Text('Start Test'),
                              ),
                            ],
                          )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _openPdf(String pdfPath, String quizName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyPdfViewer(pdfPath: pdfPath, quizName: quizName),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchResponse();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFFE586A),
          elevation: 0,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ),
        drawer: Drawer(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Stack(
            children: [
              ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Color(0xFFFE586A),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        Text(
                          "Name : ${data_variable.read('name')}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "Contact : +91 ${data_variable.read('contact')}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "Email : ${data_variable.read('email')}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "Trade : ${data_variable.read('trade')}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Add more list items as needed
                ],
              ),
              Positioned(
                bottom: 0,
                left: MediaQuery.of(context).size.width * 0.1,
                right: MediaQuery.of(context).size.width * 0.1,
                child: GestureDetector(
                  onTap: () {
                    login_email = '';
                    login_password = '';
                    signup_name = '';
                    signup_email = '';
                    signup_phone = '';
                    signup_trade = '';
                    signup_password = '';
                    data_variable.write('loggedIn', 'false');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  },
                  child: Container(
                    color: const Color.fromARGB(255, 238, 238, 238),
                    child: const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Sign Out',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 20),
                          Icon(Icons.logout),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: const Color(0xFFFE586A),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello  ${data_variable.read('name')}",
                    style: const TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  const Text(
                    "Let's test your knowledge",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Text(
                'Select Your Subject',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32.0),
                    topRight: Radius.circular(32.0),
                  ),
                ),
                child: ListView.builder(
                  itemCount: distinctSubjects.toList().length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: MyListItem(
                        title: distinctSubjects.toList()[index]!,
                        // subtitle: demoData[index]['subtitle']!,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => subjectQuiz(
                                    subject: distinctSubjects.toList()[index])),
                          );
                          // fetchResponse12(index);

                          // _openPdf(
                          //     'https://maapitambrapvtitijhansi.com/app/iti/pages/Quiz/${data_variable.read('trade')}/${demoData[index]['name']}.pdf'!,
                          //     '${data_variable.read('trade')}_${demoData[index]['name']}'!);
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class subjectQuiz extends StatefulWidget {
  String subject;

  subjectQuiz({super.key, required this.subject});

  @override
  State<subjectQuiz> createState() => _subjectQuizState();
}

class _subjectQuizState extends State<subjectQuiz> {
  bool attempted = false;
  // https://maapitambrapvtitijhansi.com/app/api/type/test/test/Fitter
  Future<Object> fetchResponse13(int index) async {
    // final url =
    //     'https://maapitambrapvtitijhansi.com/app/api/attempted?table=${data_variable.read('trade')}_${demoData[index]['name']}_result&studentID=1234';
    final url =
        'https://maapitambrapvtitijhansi.com/app/api/type/${demoData[index]['name']}/${demoData[index]['subject']}/${data_variable.read('trade')}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        if (response.body == '0') {
          print('only subject');
          _openPdf2(
              'https://maapitambrapvtitijhansi.com/pages/Quiz/${data_variable.read('trade')}/${demoData[index]['subject']}_${demoData[index]['name']}.pdf'!,
              '${data_variable.read('trade')}_${demoData[index]['subject']}_${demoData[index]['name']}'!);
        } else {
          print('Subject with Quiz');
          fetchResponse12(index);
        }

        return response.body == 'true';
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      return false;
    }
  }

  Future<Object> fetchResponse12(int index) async {
    // final url =
    //     'https://maapitambrapvtitijhansi.com/app/api/attempted?table=${data_variable.read('trade')}_${demoData[index]['name']}_result&studentID=1234';
    final url =
        'https://maapitambrapvtitijhansi.com/app/api/attempted?table=${demoData[index]['id_for_table']}_result&studentID=${data_variable.read('ID')}';
    print('${demoData[index]['subject']}');
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        if (response.body == 'false') {
          print('false');
          setState(() {
            attempted = false;
          });

          Modalbottomsheet(index, '');
        } else {
          setState(() {
            attempted = true;
          });

          Map<String, dynamic> responseData = jsonDecode(response.body);
          print(responseData['score']);
          Modalbottomsheet(index, responseData['score']);
        }

        return response.body == 'true';
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      return false;
    }
  }

  void Modalbottomsheet(int index, String scoree) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        // return QuizDescription(
        //   quizName: demoData[index]['name'],
        // );
        return Container(
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      demoData[index]['name'],
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                    Text(
                      'Your Short description for the selected test.',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.03,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    attempted == true
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Score : ',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey),
                              ),
                              const SizedBox(
                                width: 15.0,
                              ),
                              Text(
                                scoree,
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.07,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.green),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  print(demoData[index]['subject'] +
                                      "_" +
                                      demoData[index]['name']);
                                  _openPdf(
                                      'https://maapitambrapvtitijhansi.com/pages/Quiz/${data_variable.read('trade')}/${demoData[index]['subject']}_${demoData[index]['name']}.pdf'!,
                                      '${demoData[index]['id_for_table']}'!);
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor:
                                      const Color(0xFFFE586A), // Text color
                                  elevation: 0, // Elevation (shadow)
                                  minimumSize:
                                      const Size(200, 45), // Width and height
                                ),
                                child: const Text('Start Test'),
                              ),
                            ],
                          )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _openPdf(String pdfPath, String quizName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyPdfViewer(pdfPath: pdfPath, quizName: quizName),
      ),
    );
  }

  void _openPdf2(String pdfPath, String quizName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MyPdfViewer2(pdfPath: pdfPath, quizName: quizName),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // fetchResponse12();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.subject);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Your Topic"),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32.0),
            topRight: Radius.circular(32.0),
          ),
        ),
        child: Column(
          // Use Column to contain the Expanded
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: demoData.length,
                itemBuilder: (context, index) {
                  print(demoData[index]['subject']);
                  return demoData[index]['subject'] == widget.subject
                      // ? MyListItem(
                      //     title: demoData[index]['name']!,
                      //     onPressed: () {
                      //       fetchResponse13(index);
                      //     },
                      //   )
                      ? GestureDetector(
                          onTap: () {
                            fetchResponse13(index);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(
                                        10.0,
                                      ),
                                    ),
                                    border: Border.all(
                                        color: Colors.red, width: 1.3)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    demoData[index]['name']!,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  ),
                                )),
                          ))
                      : Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
