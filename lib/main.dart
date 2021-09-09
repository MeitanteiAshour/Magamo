import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:magamo/screens/painter_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Widget> _drawPages;
  int index = 0;
  CarouselController buttonCarouselController = CarouselController();

  @override
  void initState() {
    _drawPages = [DrawingPage()];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(index);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_left_outlined,
                  size: 30,
                ),
                onPressed: () => buttonCarouselController.previousPage(),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 28.0),
                child: IconButton(
                  icon: Icon(
                    Icons.keyboard_arrow_right_outlined,
                    size: 30,
                  ),
                  onPressed: () => buttonCarouselController.nextPage(),
                ))
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton.extended(
              onPressed: () {
                setState(() {
                  _drawPages.add(DrawingPage());
                  index += 1;
                  buttonCarouselController.nextPage();
                });
              },
              label: Text('Add pages')),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            CarouselSlider.builder(
              itemCount: _drawPages.length,
              options: CarouselOptions(
                aspectRatio: 0.1,
                enableInfiniteScroll: false,
                scrollPhysics: NeverScrollableScrollPhysics(),
                viewportFraction: 1,
              ),
              carouselController: buttonCarouselController,
              itemBuilder:
                  (BuildContext context, int itemIndex, int pageViewIndex) =>
                      Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: _drawPages[itemIndex],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
