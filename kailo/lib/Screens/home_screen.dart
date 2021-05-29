import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kailo/Screens/DashBoardScreen.dart';
import 'package:kailo/Screens/FeedScreen.dart';
import 'package:kailo/Screens/aboutUs.dart';
import 'package:kailo/Screens/add_activity.dart';
import 'package:kailo/Screens/userSettings.dart';
import 'package:kailo/Screens/testScreen.dart';
import 'package:kailo/resources/authentication.dart';
import 'userSettings.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = PageController();
  int pageIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    return MaterialApp(
      home: Scaffold(
        endDrawer: Drawer(
        child: Column(
            children: [
              Expanded(
                flex: 0,
                child: Container(
                  child: UserAccountsDrawerHeader(
                    accountName: Text("Ashish Rawat"),
                    accountEmail: Text("ashishrawat2911@gmail.com"),
                    currentAccountPicture: CircleAvatar(
                      radius: 250.0,
                      backgroundColor:
                          Theme.of(context).platform == TargetPlatform.iOS
                              ? Colors.blue
                              : Colors.white,
                      child: Text(
                        "A",
                        style: TextStyle(fontSize: 40.0),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: ListView(
                  children: [
                  ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text("About Us"),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.power_settings_new),
                    title: Text("LogOut"),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ]),
              )
            ],
          ),
        ),
        backgroundColor: Colors.blueGrey.shade50,
        body: PageView(
          controller: _controller,
          children: <Widget>[
            DashBoardScreen(),
            FeedScreen(),
            TestScreen(),
            UserProfile(),
          ],
        ),
        extendBody: true,
        bottomNavigationBar: FloatingBottomBar(
          controller: _controller,
          items: [
            FloatingBottomBarItem(Icons.home, label: 'Home'),
            FloatingBottomBarItem(FontAwesomeIcons.smile, label: 'Feed'),
            FloatingBottomBarItem(FontAwesomeIcons.bookOpen, label: 'Test'),
            FloatingBottomBarItem(FontAwesomeIcons.userAlt, label: 'Profile'),
          ],
          activeItemColor: Colors.purple,
          enableIconRotation: true,
          onTap: (index) {
            this.setState(() {
              pageIndex = index;
            });
            _controller.animateToPage(
              index,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeIn,
            );
          },
        ),
        floatingActionButton: showFloatingActionButton(context),
      ),
    );
  }

  Widget showFloatingActionButton(BuildContext context) {
    print(pageIndex);
    print("----------------------------------------------------");
    if (pageIndex < 2.0) {
      return FloatingActionButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (conext) => AddActivity())),
        child: const FaIcon(FontAwesomeIcons.pen),
        backgroundColor: Colors.purple[400],
      );
    }
  }

  Widget _image(String url) {
    return Image.network(
      url,
      loadingBuilder: (_, child, progress) => progress == null
          ? FittedBox(fit: BoxFit.cover, child: child)
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

//=========================================================================

const _kMargin = 14.0;
const _kHeight = 62.0;
const _kCircleRadius = 30.0;
const _kCircleMargin = 8.0;
const _kTopRadius = 10.0;
const _kBottomRadius = 28.0;
const _kItemSize = 30.0;
const _kPi = 3.1415926535897932;

class FloatingBottomBarItem {
  const FloatingBottomBarItem(this.iconData, {this.label});

  final IconData iconData;
  final String label;
}

class FloatingBottomBar extends StatefulWidget {
  const FloatingBottomBar({
    @required this.controller,
    @required this.items,
    @required this.onTap,
    this.color,
    this.itemColor,
    this.activeItemColor,
    this.enableIconRotation,
  });

  final PageController controller;
  final List<FloatingBottomBarItem> items;
  final ValueChanged<int> onTap;
  final Color color;
  final Color itemColor;
  final Color activeItemColor;
  final bool enableIconRotation;

  @override
  _FloatingBottomBarState createState() => _FloatingBottomBarState();
}

class _FloatingBottomBarState extends State<FloatingBottomBar> {
  double _screenWidth;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenWidth = MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    const height = _kHeight + _kMargin * 2;

    return AnimatedBuilder(
      animation: widget.controller,
      builder: (_, child) {
        var scrollPosition = 0.0;
        var currentIndex = 0;
        if (widget.controller?.hasClients ?? false) {
          scrollPosition = widget.controller.page;
          currentIndex = (widget.controller.page + 0.5).toInt();
        }

        return Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            CustomPaint(
              size: Size(width, height),
              painter: _Painter(
                x: _itemXByScrollPosition(scrollPosition),
                color: widget.color,
              ),
            ),
            for (var i = 0; i < widget.items.length; i++) ...[
              if (i == currentIndex)
                Positioned(
                  top: _kMargin - _kCircleRadius + 8.0,
                  left: _kCircleMargin + _itemXByScrollPosition(scrollPosition),
                  child: _ActiveItem(
                    i,
                    iconData: widget.items[i].iconData,
                    color: widget.activeItemColor,
                    scrollPosition: scrollPosition,
                    enableRotation: widget.enableIconRotation,
                    onTap: widget.onTap,
                  ),
                ),
              if (i != currentIndex)
                Positioned(
                  top: _kMargin + (_kHeight - _kCircleRadius * 2) / 2,
                  left: _kCircleMargin + _itemXByIndex(i),
                  child: _Item(
                    i,
                    iconData: widget.items[i].iconData,
                    label: widget.items[i].label,
                    color: widget.itemColor,
                    onTap: widget.onTap,
                  ),
                ),
            ],
          ],
        );
      },
    );
  }

  double _firstItemX() {
    return _kMargin + (_screenWidth - _kMargin * 2) * 0.1;
  }

  double _lastItemX() {
    return _screenWidth -
        _kMargin -
        (_screenWidth - _kMargin * 2) * 0.1 -
        (_kCircleRadius + _kCircleMargin) * 2;
  }

  double _itemDistance() {
    return (_lastItemX() - _firstItemX()) / (widget.items.length - 1);
  }

  double _itemXByScrollPosition(double scrollPosition) {
    return _firstItemX() + _itemDistance() * scrollPosition;
  }

  double _itemXByIndex(int index) {
    return _firstItemX() + _itemDistance() * index;
  }
}

class _Item extends StatelessWidget {
  const _Item(this.index, {this.iconData, this.label, this.color, this.onTap});

  final int index;
  final IconData iconData;
  final String label;
  final Color color;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: SizedBox.fromSize(
        size: const Size(_kCircleRadius * 2, _kCircleRadius * 2),
        child: RawMaterialButton(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                iconData,
                size: _kItemSize - 4,
                color: color ?? Colors.grey.shade700,
              ),
              if (label != null) ...[
                const SizedBox(height: 3.0),
                Text(
                  label,
                  style: TextStyle(
                    color: color ?? Colors.grey.shade700,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ],
          ),
          onPressed: () => onTap(index),
        ),
      ),
    );
  }
}

class _ActiveItem extends StatelessWidget {
  const _ActiveItem(
    this.index, {
    this.iconData,
    this.color,
    this.scrollPosition,
    this.enableRotation,
    this.onTap,
  });

  final int index;
  final IconData iconData;
  final Color color;
  final double scrollPosition;
  final bool enableRotation;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final icon = Icon(
      iconData,
      size: _kItemSize,
      color: color ?? Colors.grey.shade700,
    );

    return InkWell(
      child: SizedBox.fromSize(
        size: const Size(_kCircleRadius * 2, _kCircleRadius * 2),
        child: enableRotation ?? false
            ? Transform.rotate(
                angle: _kPi * 2 * (scrollPosition % 1),
                child: icon,
              )
            : icon,
      ),
      onTap: () => onTap(index),
    );
  }
}

class _Painter extends CustomPainter {
  _Painter({@required this.x, this.color})
      : _paint = Paint()
          ..color = color ?? Colors.white
          ..isAntiAlias = true,
        _shadowColor =
            kIsWeb ? Colors.grey.shade600 : Colors.grey.withOpacity(0.4);

  final double x;
  final Color color;
  final Paint _paint;
  final Color _shadowColor;

  @override
  void paint(Canvas canvas, Size size) {
    _drawBar(canvas, size);
    _drawCircle(canvas);
  }

  @override
  bool shouldRepaint(_Painter oldDelegate) {
    return x != oldDelegate.x || color != oldDelegate.color;
  }

  void _drawBar(Canvas canvas, Size size) {
    const left = _kMargin;
    final right = size.width - _kMargin;
    const top = _kMargin;
    const bottom = top + _kHeight;

    final path = Path()
      ..moveTo(left + _kTopRadius, top)
      ..lineTo(x - _kTopRadius, top)
      ..relativeArcToPoint(
        const Offset(_kTopRadius, _kTopRadius),
        radius: const Radius.circular(_kTopRadius),
      )
      ..relativeArcToPoint(
        const Offset((_kCircleRadius + _kCircleMargin) * 2, 0.0),
        radius: const Radius.circular(_kCircleRadius + _kCircleMargin),
        clockwise: false,
      )
      ..relativeArcToPoint(
        const Offset(_kTopRadius, -_kTopRadius),
        radius: const Radius.circular(_kTopRadius),
      )
      ..lineTo(right - _kTopRadius, top)
      ..relativeArcToPoint(
        const Offset(_kTopRadius, _kTopRadius),
        radius: const Radius.circular(_kTopRadius),
      )
      ..lineTo(right, bottom - _kBottomRadius)
      ..relativeArcToPoint(
        const Offset(-_kBottomRadius, _kBottomRadius),
        radius: const Radius.circular(_kBottomRadius),
      )
      ..lineTo(left + _kBottomRadius, bottom)
      ..relativeArcToPoint(
        const Offset(-_kBottomRadius, -_kBottomRadius),
        radius: const Radius.circular(_kBottomRadius),
      )
      ..lineTo(left, top + _kTopRadius)
      ..relativeArcToPoint(
        const Offset(_kTopRadius, -_kTopRadius),
        radius: const Radius.circular(_kTopRadius),
      );

    canvas
      ..drawShadow(path, _shadowColor, 5.0, false)
      ..drawPath(path, _paint);
  }

  void _drawCircle(Canvas canvas) {
    final path = Path()
      ..addArc(
        Rect.fromCircle(
          center: Offset(
            x + _kCircleMargin + _kCircleRadius,
            _kMargin + _kCircleMargin,
          ),
          radius: _kCircleRadius,
        ),
        0,
        _kPi * 2,
      );

    canvas
      ..drawShadow(path, _shadowColor, 1.0, false)
      ..drawPath(path, _paint);
  }
}
