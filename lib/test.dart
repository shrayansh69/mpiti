import 'package:flutter/material.dart';
import 'package:mppiti/Home/Home.dart';
import 'package:mppiti/mcq.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class MyPdfViewer extends StatefulWidget {
  final String pdfPath;
  final String quizName;

  const MyPdfViewer({required this.pdfPath, required this.quizName});

  @override
  State<MyPdfViewer> createState() => _MyPdfViewerState();
}

class _MyPdfViewerState extends State<MyPdfViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('PDF Viewer'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SfPdfViewer.network(widget.pdfPath)),
          Positioned(
            bottom: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.14,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MCQTestPage(quizName: widget.quizName)));
                  },
                  child: Container(
                    height: 48,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      color: const Color(0xffFE586A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text(
                        'Start Test',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MyPdfViewer2 extends StatefulWidget {
  final String pdfPath;
  final String quizName;

  const MyPdfViewer2({required this.pdfPath, required this.quizName});

  @override
  State<MyPdfViewer2> createState() => _MyPdfViewer2State();
}

class _MyPdfViewer2State extends State<MyPdfViewer2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('PDF Viewer'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SfPdfViewer.network(widget.pdfPath)),
          // Positioned(
          //   bottom: 0,
          //   child: Container(
          //     height: MediaQuery.of(context).size.height * 0.14,
          //     width: MediaQuery.of(context).size.width,
          //     color: Colors.white,
          //     child: Center(
          //       child: GestureDetector(
          //         onTap: () {
          //           Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                   builder: (context) =>
          //                       MCQTestPage(quizName: widget.quizName)));
          //         },
          //         child: Container(
          //           height: 48,
          //           width: MediaQuery.of(context).size.width * 0.8,
          //           decoration: BoxDecoration(
          //             color: const Color(0xffFE586A),
          //             borderRadius: BorderRadius.circular(20),
          //           ),
          //           child: const Center(
          //             child: Text(
          //               'Start Test',
          //               style: TextStyle(color: Colors.white, fontSize: 16),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
