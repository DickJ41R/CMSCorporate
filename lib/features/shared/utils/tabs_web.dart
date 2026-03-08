import 'package:cms_web/features/clientapp/views/profile/client_stream_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cms_web/features/shared/services/routes.dart';

class TabsWeb extends StatefulWidget {
  final title;
  final route;
  final int? argumentId;
  final Map<String, dynamic>? argumentMap;
  const TabsWeb(
      {Key? key, this.title, this.route, this.argumentId, this.argumentMap})
      : super(key: key);

  @override
  State<TabsWeb> createState() => _TabsWebState();
}

class _TabsWebState extends State<TabsWeb> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('line 20: ${widget.route}');
        Navigator.of(context).pushNamed(widget.route,
            arguments: widget.argumentId != -1
                ? widget.argumentId
                : widget.argumentMap);
      },
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            isSelected = true;
          });
        },
        onExit: (_) {
          setState(() {
            isSelected = false;
          });
        },
        child: AnimatedDefaultTextStyle(
          duration: Duration(milliseconds: 100),
          curve: Curves.elasticIn,
          style: isSelected
              ? GoogleFonts.roboto(
                  shadows: [Shadow(color: Colors.black, offset: Offset(0, -8))],
                  fontSize: 25.0,
                  color: Colors.transparent,
                  decoration: TextDecoration.underline,
                  decorationThickness: 2,
                  decorationColor: Colors.tealAccent,
                )
              : GoogleFonts.roboto(color: Colors.black, fontSize: 20.0),
          child: Text(widget.title),
        ),
      ),
    );
  }
}

class SansBold extends StatelessWidget {
  final text;
  final size;
  const SansBold(this.text, this.size, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: GoogleFonts.openSans(
          fontSize: size,
          fontWeight: FontWeight.bold,
        ));
  }
}

class Sans extends StatelessWidget {
  final text;
  final size;
  const Sans(this.text, this.size, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: GoogleFonts.openSans(
          fontSize: size,
        ));
  }
}

class TextForm extends StatelessWidget {
  final text;
  final containerWidth;
  final hintText;
  final maxLines;
  const TextForm(
      {Key? key,
      required this.text,
      required this.containerWidth,
      required this.hintText,
      this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Sans(text, 16.0),
        SizedBox(height: 5.0),
        SizedBox(
          width: containerWidth,
          child: TextFormField(
            // inputFormatters: [
            //   LengthLimitingTextInputFormatter(10),
            //   FilteringTextInputFormatter.allow(RegExp('[a-z]'))
            // ],
            maxLines: maxLines == null ? null : maxLines,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.tealAccent, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              hintText: hintText,
              hintStyle: GoogleFonts.poppins(fontSize: 14),
            ),
            // validator: (text) {
            //   if (RegExp("\\bpaulina\\b",caseSensitive: false).hasMatch(text.toString()) ) {
            //     return "match found";
            //   }
            // },
            // autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
        ),
      ],
    );
  }
}

class AnimatedCard extends StatefulWidget {
  final imagePath;
  final text;
  final fit;
  final reverse;
  final height;
  final width;
  const AnimatedCard(
      {super.key,
      required this.imagePath,
      this.text,
      this.fit,
      this.reverse,
      this.height,
      this.width});

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller =
      AnimationController(vsync: this, duration: Duration(seconds: 4))
        ..repeat(reverse: true);

  late Animation<Offset> _animation = Tween(
    begin: widget.reverse == true ? Offset(0, 0.08) : Offset.zero,
    end: widget.reverse == true ? Offset.zero : Offset(0, 0.08),
  ).animate(_controller);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Card(
          elevation: 30,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(color: Colors.tealAccent),
          ),
          shadowColor: Colors.tealAccent,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Image.asset(widget.imagePath,
                  height: widget.height == null ? 200 : widget.height,
                  width: widget.width == null ? 200 : widget.width,
                  fit: widget.fit == null ? null : widget.fit),
              SizedBox(height: 10),
              widget.text == null ? SizedBox() : SansBold(widget.text, 15),
            ]),
          )),
    );
  }
}

class VerticalTile extends StatefulWidget {
  final Map<String, dynamic> menuItem;
  final Map<String, dynamic> arguments;
  const VerticalTile(
      {Key? key, required this.menuItem, required this.arguments})
      : super(key: key);

  @override
  State<VerticalTile> createState() => _VerticalTileState();
}

class _VerticalTileState extends State<VerticalTile> {
  bool isSelected = false;
  Map<String, dynamic>? menuItem;
  Map<String, dynamic>? arguments;
  String routeName = '';
  @override
  void initState() {
    super.initState();
    menuItem = widget.menuItem;
    routeName = menuItem!['menuRouteName'];
    arguments = widget.arguments;
    print('line 235: $menuItem $arguments $routeName');
  }

  @override
  Widget build(BuildContext context) {
    //print('line 240 in build context');
    return Container(
      height: 50,
      width: 300,
      child: GestureDetector(
        onTap: () {
          print('line 20: ${menuItem}');
          Navigator.of(context).pushNamed(routeName, arguments: arguments!);
        },
        child: MouseRegion(
          onEnter: (_) {
            setState(() {
              isSelected = true;
            });
          },
          onExit: (_) {
            setState(() {
              isSelected = false;
            });
          },
          child: Center(
            child: Container(
              height: 40,
              width: 300,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(width: 2.0, color: Colors.black)),
              child: Center(
                child: Text(menuItem!['menuName'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class VerticalTile1 extends StatefulWidget {
  final Map<String, dynamic> menuItem;
  final Map<String, dynamic> arguments;
  const VerticalTile1(
      {Key? key, required this.menuItem, required this.arguments})
      : super(key: key);

  @override
  State<VerticalTile1> createState() => _VerticalTile1State();
}

class _VerticalTile1State extends State<VerticalTile1> {
  bool isSelected = false;
  Map<String, dynamic>? menuItem;
  Map<String, dynamic>? arguments;
  String routeName = '';
  @override
  void initState() {
    super.initState();
    menuItem = widget.menuItem;
    routeName = menuItem!['menuRouteName'];
    arguments = widget.arguments;
    print('line 235: $menuItem $arguments $routeName');
  }

  @override
  Widget build(BuildContext context) {
    //print('line 240 in build context');
    return Container(
      height: 50,
      width: 300,
      child: GestureDetector(
        onTap: () {
          print('line 20: ${menuItem}');
          Navigator.of(context).pushNamed(routeName, arguments: arguments!);
        },
        child: MouseRegion(
          onEnter: (_) {
            setState(() {
              isSelected = true;
            });
          },
          onExit: (_) {
            setState(() {
              isSelected = false;
            });
          },
          child: Center(
            child: Container(
              height: 40,
              width: 300,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(width: 2.0, color: Colors.black)),
              child: Center(
                child: Text(menuItem!['menuName'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
