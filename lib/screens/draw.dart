// import 'dart:io';
// import 'dart:ui';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';

// class DrawingArea {
//   Offset point;
//   Paint areaPaint;

//   DrawingArea({this.point, this.areaPaint});
// }

// class DrawPage extends StatefulWidget {
//   @override
//   _DrawPageState createState() => _DrawPageState();
// }

// class _DrawPageState extends State<DrawPage>
//     with AutomaticKeepAliveClientMixin {
//   List<DrawingArea> points;
//   Color selectedColor;
//   bool _eraserMode = false;
//   double strokeWidth;
//   List<PlatformFile> _paths = [];
//   double dx = 0;
//   double dy = 0;
//   String _filePath = "";
//   @override
//   void initState() {
//     super.initState();
//     selectedColor = Colors.black;
//     strokeWidth = 2.0;
//     points = [];
//   }

//   void selectColor() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Color Chooser'),
//           content: SingleChildScrollView(
//             child: BlockPicker(
//               pickerColor: selectedColor,
//               onColorChanged: (color) {
//                 this.setState(() {
//                   if (color != Colors.white)
//                     selectedColor = color;
//                   else
//                     selectedColor = Colors.black;
//                 });
//               },
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text("Close"))
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     final double width = MediaQuery.of(context).size.width;
//     final double height = MediaQuery.of(context).size.height;

//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.black,
//         child: Text('Image'),
//         onPressed: () async {
//           final _pickedFiles = await FilePicker.platform.pickFiles(
//             dialogTitle: 'Upload your image',
//             type: FileType.image,
//             allowMultiple: true,
//           );
//           setState(() => _paths.addAll(_pickedFiles.files));
//         },
//       ),
//       body: Stack(
//         children: <Widget>[
//           _filePath == ""
//               ? SizedBox.shrink()
//               : Center(child: Image.file(File('$_filePath'))),
//           Center(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     width: width * 0.80,
//                     height: height * 0.80,
//                     child: GestureDetector(
//                       onPanDown: (details) {
//                         this.setState(() {
//                           DrawingArea a = DrawingArea(
//                               point: details.localPosition,
//                               areaPaint: Paint()
//                                 ..strokeCap = StrokeCap.round
//                                 ..isAntiAlias = true
//                                 ..color = selectedColor
//                                 ..strokeWidth = strokeWidth);
//                           points.add(a);
//                         });
//                       },
//                       onPanUpdate: (details) {
//                         this.setState(() {
//                           DrawingArea a = DrawingArea(
//                               point: details.localPosition,
//                               areaPaint: Paint()
//                                 ..strokeCap = StrokeCap.round
//                                 ..isAntiAlias = true
//                                 ..color = selectedColor
//                                 ..strokeWidth = strokeWidth);
//                           points.add(a);
//                         });
//                       },
//                       onPanEnd: (details) =>
//                           this.setState(() => points.add(null)),
//                       child: SizedBox.expand(
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.all(Radius.circular(20.0)),
//                           child: CustomPaint(
//                             painter: MyCustomPainter(points: points),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Container(
//                     width: width * 0.80,
//                     decoration: BoxDecoration(
//                         color: Colors.black,
//                         borderRadius: BorderRadius.all(Radius.circular(20.0))),
//                     child: Row(
//                       children: <Widget>[
//                         IconButton(
//                             icon: Icon(
//                               Icons.color_lens,
//                               color: selectedColor == Colors.black
//                                   ? Colors.white
//                                   : selectedColor,
//                             ),
//                             onPressed: () => selectColor()),
//                         // IconButton(
//                         //     icon: Icon(
//                         //       Icons.delete_sweep_rounded,
//                         //       color: selectedColor == Colors.white
//                         //           ? previousColor
//                         //           : selectedColor,
//                         //     ),
//                         //     onPressed: () {
//                         //       print("Going inside function");
//                         //       // this.setState(() {
//                         //       //   if (selectedColor != Colors.white)
//                         //       //     previousColor = selectedColor;
//                         //       //   selectedColor = Colors.white;
//                         //       // });
//                         //     }),
//                         Expanded(
//                           child: Slider(
//                             min: 1.0,
//                             max: 5.0,
//                             label: "Stroke $strokeWidth",
//                             activeColor: selectedColor == Colors.black
//                                 ? Colors.white
//                                 : selectedColor,
//                             value: strokeWidth,
//                             onChanged: (double value) {
//                               this.setState(() {
//                                 strokeWidth = value;
//                               });
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Align(
//             alignment: Alignment.centerRight,
//             child: Container(
//               width: MediaQuery.of(context).size.width / 8,
//               child: ListView.builder(
//                 itemCount: _paths.length,
//                 itemBuilder: (c, i) => Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: GestureDetector(
//                     onTap: () => setState(() => _filePath = _paths[i].path),
//                     child: Container(
//                         child: Image.file(File('${_paths[i].path}')),
//                         width: 100,
//                         height: 100),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   bool get wantKeepAlive => true;
// }

// class MyCustomPainter extends CustomPainter {
//   List<DrawingArea> points;

//   MyCustomPainter({@required this.points});

//   @override
//   void paint(Canvas canvas, Size size) { 

//     canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());
//     Paint background = Paint()..color = Colors.transparent;
//     Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
//     canvas.drawRect(rect, background);
//     canvas.clipRect(rect);
//     for (int x = 0; x < points.length - 1; x++) {
//       if (points[x] != null && points[x + 1] != null) {
//         canvas.drawLine(points[x].point, points[x + 1].point,
//             points[x].areaPaint);
//       } else if (points[x] != null && points[x + 1] == null) {
//         canvas.drawPoints(PointMode.points, [points[x].point],
//             points[x].areaPaint);
//       }
//     }
//     canvas.restore();
//   }

//   @override
//   bool shouldRepaint(MyCustomPainter oldDelegate) => true;
// }
