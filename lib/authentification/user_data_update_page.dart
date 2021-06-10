import 'dart:typed_data';

import 'package:flexible/authentification/bloc/auth_bloc.dart';
import 'package:flexible/board/widgets/glassmorph_layer.dart';
import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flexible/utils/main_backgroung_gradient.dart';
import 'package:flexible/utils/validators.dart';
import 'package:flexible/widgets/wide_rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class UserDataUpdatePage extends StatefulWidget {
  const UserDataUpdatePage({Key? key}) : super(key: key);

  @override
  _UserDataUpdatePageState createState() => _UserDataUpdatePageState();
}

class _UserDataUpdatePageState extends State<UserDataUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  String fullName = '';
  String email = '';
  Uint8List? _image;
  final picker = ImagePicker();

  Future getImage() async {
    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _image = await pickedFile.readAsBytes();
        setState(() {});
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error on load image');
    }
  }

  bool get submitActive => fullName.isNotEmpty && email.isNotEmpty;

  onSubmit() {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context)
          .add(AddData(email: email, name: fullName, photo: _image));
    }
  }

  @override
  Widget build(BuildContext context) {
    double safeTopPadding = MediaQuery.of(context).padding.top;
    double safeBottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      // backgroundColor: Color(0xffE9E9E9),
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            gradient: mainBackgroundGradient,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        safeTopPadding -
                        safeBottomPadding),
                child: IntrinsicHeight(
                  child: buildBody(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column buildBody(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16 * byWithScale(context)),
        Text(
          'fleXible',
          style: TextStyle(
              color: Color(0xffE24F4F),
              fontSize: 24 * byWithScale(context),
              fontWeight: FontWeight.w700),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(16 * byWithScale(context)),
            child: Stack(
              children: [
                Positioned.fill(child: GlassmorphLayer()),
                SizedBox(
                  // height: 500,
                  child: Column(
                    children: [
                      Spacer(
                        flex: 1,
                      ),
                      Text(
                        'Update data',
                        style: TextStyle(
                            color: Color(0xffE24F4F),
                            fontSize: 20 * byWithScale(context),
                            fontWeight: FontWeight.w700),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(30 * byWithScale(context)),
                        child: Material(
                          color: Colors.grey[300],
                          child: InkWell(
                            onTap: () => getImage(),
                            child: Container(
                              height: 60 * byWithScale(context),
                              width: 60 * byWithScale(context),
                              child: _image != null
                                  ? Image.memory(
                                      _image!,
                                      fit: BoxFit.cover,
                                    )
                                  : Center(
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              buildFullNameInput(),
                              SizedBox(
                                height: 32,
                              ),
                              buildEmailInput(),
                            ],
                          )),
                      Spacer(
                        flex: 4,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 60 * byWithScale(context)),
              child: WideRoundedButton(
                text: 'Update data',
                enable: submitActive,
                textColor: Colors.white,
                enableColor: Color(0xffE24F4F),
                disableColor: Color(0xffE24F4F).withOpacity(0.25),
                callback: () => submitActive ? onSubmit() : {},
              ),
            ),
          ],
        ),
        SizedBox(height: 16 * byWithScale(context)),
      ],
    );
  }

  Widget buildFullNameInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: TextFormField(
        style: TextStyle(fontSize: 10 * byWithScale(context)),
        keyboardType: TextInputType.name,
        validator: (value) {
          print(value);
          return nameValidator(value!);
        },
        decoration: InputDecoration(
            hintText: 'Full name',
            isDense: true,
            contentPadding: EdgeInsets.all(8 * byWithScale(context)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Color(0xffFA6400))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Color(0xffC9C9C9))),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Color(0xffC9C9C9))),
            fillColor: Colors.white,
            filled: true),
        onChanged: (value) {
          setState(() {
            fullName = value;
          });
        },
      ),
    );
  }

  Widget buildEmailInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          return emailValidator(value!);
        },
        style: TextStyle(fontSize: 10 * byWithScale(context)),
        decoration: InputDecoration(
            hintText: 'Email',
            isDense: true,
            contentPadding: EdgeInsets.all(8 * byWithScale(context)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Color(0xffFA6400))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Color(0xffC9C9C9))),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Color(0xffC9C9C9))),
            fillColor: Colors.white,
            filled: true),
        onChanged: (value) {
          setState(() {
            email = value;
          });
        },
      ),
    );
  }
}
