import 'package:flexible/ai/text2icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flexible/board/repository/image_repo_mock.dart';
import 'package:flexible/board/widgets/task_tiles/components/cached_icon.dart';
import 'package:flexible/board/widgets/weather_bg.dart';
import 'package:flexible/utils/adaptive_utils.dart';

class IconPickerPage extends StatefulWidget {
  final String text;
  const IconPickerPage({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  _IconPickerPageState createState() => _IconPickerPageState();
}

class _IconPickerPageState extends State<IconPickerPage> {
  bool switchValue = false;
  Text2Icon text2icon = Text2Icon();

  @override
  void initState() {
    super.initState();
    getSwitchValues();
    // classify();
  }

  Future<List<String>> classify() async {
    List<String> result = await text2icon.classify(widget.text);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SizedBox.expand(
          child: CustomScrollView(
            physics: NeverScrollableScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: true,
                child: Stack(children: [
                  Container(
                    child: WeatherBg(),
                    width: double.maxFinite,
                    height: double.maxFinite,
                  ),
                  SafeArea(child: buildBody(context))
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(28),
      child: Stack(
        children: [
          // the glass layer
          // fill uses for adopt is size
          Positioned.fill(child: buildGlassmorphicLayer()),
          Column(
            children: [
              Row(
                children: [
                  buildCloseButton(),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Center(
                        child: Text(
                          ' Give it an icon',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              buildImproveSwitch(),
              switchValue
                  ? Expanded(child: buildPredictionImagesGrid(context))
                  : Expanded(child: buildImagesGrid(context)),
              SizedBox(
                height: 16,
              ),
            ],
          )
        ],
      ),
    );
  }

  Padding buildPredictionImagesGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: FutureBuilder(
        future: classify(),
        builder: (context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.hasData) {
            return SizedBox(
              // height: 60,
              child: GridView.count(
                // shrinkWrap: true,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                crossAxisCount: 5,
                children: snapshot.data!
                    .map((e) => Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: buildImageLoader(context, e),
                        ))
                    .toList(),
              ),
            );
          }
          return SizedBox(
            height: 60,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }

  Padding buildImagesGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: FutureBuilder(
        future: RepositoryProvider.of<ImageRepoMock>(context).allIds,
        builder: (context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.hasData) {
            return SizedBox(
              // height: 400,
              child: GridView.count(
                // shrinkWrap: true,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                crossAxisCount: 5,
                children: snapshot.data!
                    .map((e) => Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: buildImageLoader(context, e),
                        ))
                    .toList(),
              ),
            );
          }
          return Center(child: SizedBox());
        },
      ),
    );
  }

  Widget buildImageLoader(BuildContext context, String id) {
    return GestureDetector(
      onTap: () => Navigator.pop(context, id),
      child: Center(
          child: CachedIcon(
        imageID: id,
        key: Key(id),
      )),
    );
  }

  Padding buildImproveSwitch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Center(
        child: Row(
          children: [
            Text(
              "Improve smart icons",
              style: TextStyle(color: Colors.white),
            ),
            Spacer(),
            Switch(
                value: switchValue,
                onChanged: (onChanged) {
                  setState(() {
                    switchValue = !switchValue;
                    switchValue = onChanged;
                    saveSwitchState(onChanged);
                  });
                })
          ],
        ),
      ),
    );
  }

  getSwitchValues() async {
    switchValue = await getSwitchState();
    setState(() {});
  }

  Future<bool> saveSwitchState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("switchState", value);
    print('Switch Value saved $value');
    return prefs.setBool("switchState", value);
  }

  Future<bool> getSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isSwitchedFT = prefs.getBool("switchState") ?? false;

    return isSwitchedFT;
  }

  GlassmorphicContainer buildGlassmorphicLayer() {
    return GlassmorphicContainer(
      width: double.maxFinite,
      height: double.maxFinite,
      borderRadius: 40,
      blur: 5,
      border: 2,
      linearGradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFFffffff).withOpacity(0.6),
            Color(0xfff4f3f3).withOpacity(0.2),
            Color(0xFFffffff).withOpacity(0.6),
          ],
          stops: [
            0,
            0.2,
            1,
          ]),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFffffff).withOpacity(0.15),
          Color(0xFFffffff).withOpacity(0.15),
          Color(0xFFFFFFFF).withOpacity(0.15),
        ],
      ),
    );
  }

  Widget buildCloseButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: 16 * byWithScale(context),
                right: 16 * byWithScale(context),
                top: 12 * byWithScale(context)),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Icon(
                Icons.close,
                size: 18 * byWithScale(context),
              ),
            ),
          )
        ],
      ),
    );
  }
}
