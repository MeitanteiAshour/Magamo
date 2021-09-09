import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:painter/painter.dart';

class DrawingPage extends StatefulWidget {
  @override
  _DrawingPageState createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage>
    with AutomaticKeepAliveClientMixin {
  bool _finished = false;
  PainterController _controller = _controllerInitializer();
  List<PlatformFile> _paths = [];

  String _filePath = "";
  @override
  void initState() {
    super.initState();
  }

  static PainterController _controllerInitializer() {
    PainterController controller = PainterController();
    controller.thickness = 5.0;
    controller.backgroundColor = Colors.transparent;
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<Widget> actions;
    if (_finished) {
      actions = <Widget>[
        IconButton(
          icon: Icon(Icons.content_copy),
          tooltip: 'Painting',
          onPressed: () => setState(() {
            _finished = false;
            _controller = _controllerInitializer();
          }),
        ),
      ];
    } else {
      actions = <Widget>[
        IconButton(
            icon: Icon(
              Icons.undo,
            ),
            tooltip: 'Undo',
            onPressed: () {
              if (_controller.isEmpty) {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) => Text('Nothing to undo'));
              } else {
                _controller.undo();
              }
            }),
        IconButton(
            icon: Icon(Icons.delete),
            tooltip: 'Clear',
            onPressed: _controller.clear),
      ];
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Text('Image'),
        onPressed: () async {
          final _pickedFiles = await FilePicker.platform.pickFiles(
            dialogTitle: 'Upload your image',
            type: FileType.image,
            allowMultiple: true,
          );
          setState(() => _paths.addAll(_pickedFiles.files));
        },
      ),
      appBar: AppBar(
          actions: actions,
          bottom: PreferredSize(
            child: DrawBar(_controller),
            preferredSize: Size(MediaQuery.of(context).size.width, 30.0),
          )),
      body: Center(
        child: Container(
          child: Stack(
            children: [
              _filePath == ""
                  ? SizedBox.shrink()
                  : Center(child: Image.file(File('$_filePath'))),
              Painter(_controller),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: MediaQuery.of(context).size.width / 8,
                  child: ListView.builder(
                    itemCount: _paths.length,
                    itemBuilder: (c, i) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => setState(() => _filePath = _paths[i].path),
                        child: Container(
                            child: Image.file(File('${_paths[i].path}')),
                            width: 100,
                            height: 100),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class DrawBar extends StatelessWidget {
  final PainterController _controller;

  DrawBar(this._controller);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                  child: Slider(
                value: _controller.thickness,
                onChanged: (double value) =>
                    setState(() => _controller.thickness = value),
                min: 1.0,
                max: 20.0,
                activeColor: Colors.white,
              ));
            },
          ),
        ),
        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return RotatedBox(
              quarterTurns: _controller.eraseMode ? 2 : 0,
              child: IconButton(
                  icon: Icon(Icons.create),
                  tooltip: (_controller.eraseMode ? 'Disable' : 'Enable') +
                      ' eraser',
                  onPressed: () {
                    setState(() {
                      _controller.eraseMode = !_controller.eraseMode;
                    });
                  }));
        }),
        ColorPickerButton(_controller, false),
      ],
    );
  }
}

class ColorPickerButton extends StatefulWidget {
  final PainterController _controller;
  final bool _background;

  ColorPickerButton(this._controller, this._background);

  @override
  _ColorPickerButtonState createState() => _ColorPickerButtonState();
}

class _ColorPickerButtonState extends State<ColorPickerButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(_iconData, color: _color),
        tooltip: widget._background
            ? 'Change background color'
            : 'Change draw color',
        onPressed: _pickColor);
  }

  void _pickColor() {
    Color pickerColor = _color;
    Navigator.of(context)
        .push(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return Scaffold(
                  appBar: AppBar(
                    title: const Text('Pick color'),
                  ),
                  body: Container(
                      alignment: Alignment.center,
                      child: ColorPicker(
                        pickerColor: pickerColor,
                        onColorChanged: (Color c) => pickerColor = c,
                      )));
            }))
        .then((_) {
      setState(() {
        _color = pickerColor;
      });
    });
  }

  Color get _color => widget._background
      ? widget._controller.backgroundColor
      : widget._controller.drawColor;

  IconData get _iconData =>
      widget._background ? Icons.format_color_fill : Icons.brush;

  set _color(Color color) {
    if (widget._background) {
      widget._controller.backgroundColor = color;
    } else {
      widget._controller.drawColor = color;
    }
  }
}
