import 'dart:typed_data';

import 'package:flexible/board/repository/image_repo_mock.dart';
import 'package:flexible/board/widgets/close_button.dart';
import 'package:flexible/board/widgets/weather_bg.dart';
import 'package:flexible/utils/main_backgroung_gradient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IconPickerPage extends StatefulWidget {
  const IconPickerPage({
    Key? key,
  }) : super(key: key);

  @override
  _IconPickerPageState createState() => _IconPickerPageState();
}

class _IconPickerPageState extends State<IconPickerPage> {
  bool switchValue = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSwitchValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xffE9E9E9),
      body: SafeArea(
          child: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            gradient: mainBackgroundGradient,
          ),
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: true,
                child: Stack(children: [
                  Container(
                    child: WeatherBg(),
                    width: double.maxFinite,
                  ),
                  buildBody(context)
                ]),
              ),
            ],
          ),
        ),
      )),
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
                  CloseButtonn(),
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
              Expanded(child: buildImagesGrid(context)),
              SizedBox(
                height: 16,
              ),
            ],
          )
        ],
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
            // print(snapshot.data);

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
          return SizedBox();
        },
      ),
    );
  }

  Widget buildImageLoader(BuildContext context, String id) {
    return GestureDetector(
      onTap: () => Navigator.pop(context, id),
      child: Center(
        child: FutureBuilder(
          future: RepositoryProvider.of<ImageRepoMock>(context).imageById(id),
          builder: (context, AsyncSnapshot<Uint8List> snapshot) {
            if (snapshot.hasData) {
              return Image.memory(
                snapshot.data!,
                width: 18,
                height: 18,
                gaplessPlayback: true,
              );
            }

            return Image.asset(
              'src/task_icons/noimage.png',
              width: 18,
              height: 18,
              gaplessPlayback: true,
            );
          },
        ),
      ),
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
                  switchValue = onChanged;
                  saveSwitchState(onChanged);
                  print('Saved state is $switchValue');
                  //switch works
                });
                print(switchValue);
              },
            )
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
    bool? isSwitchedFT = prefs.getBool("switchState");
    print(isSwitchedFT);

    return isSwitchedFT!;
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
}
