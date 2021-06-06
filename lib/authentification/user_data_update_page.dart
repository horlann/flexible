import 'package:flexible/authentification/bloc/auth_bloc.dart';
import 'package:flexible/board/widgets/glassmorph_layer.dart';
import 'package:flexible/utils/main_backgroung_gradient.dart';
import 'package:flexible/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDataUpdatePage extends StatefulWidget {
  const UserDataUpdatePage({Key? key}) : super(key: key);

  @override
  _UserDataUpdatePageState createState() => _UserDataUpdatePageState();
}

class _UserDataUpdatePageState extends State<UserDataUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  String fullName = '';
  String email = '';

  bool get submitActive => fullName.isNotEmpty && email.isNotEmpty;

  onSubmit() {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context)
          .add(AddData(email: email, name: fullName));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xffE9E9E9),
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            gradient: mainBackgroundGradient,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  SizedBox(
                    height: 32,
                  ),
                  Text(
                    'fleXible',
                    style: TextStyle(
                        color: Color(0xffE24F4F),
                        fontSize: 32,
                        fontWeight: FontWeight.w700),
                  ),
                  Padding(
                    padding: EdgeInsets.all(32),
                    child: Stack(
                      children: [
                        Positioned.fill(child: GlassmorphLayer()),
                        SizedBox(
                          height: 500,
                          child: Column(
                            children: [
                              SizedBox(
                                width: double.maxFinite,
                              ),
                              SizedBox(
                                height: 32,
                              ),
                              Text(
                                'Update data',
                                style: TextStyle(
                                    color: Color(0xffE24F4F),
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: 32,
                              ),
                              Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(40)),
                                child: Center(
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 32,
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
                              SizedBox(
                                height: 32,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () => submitActive ? onSubmit() : {},
                        child: Container(
                          height: 40,
                          width: double.maxFinite,
                          margin: EdgeInsets.symmetric(horizontal: 40),
                          decoration: BoxDecoration(
                              color: submitActive
                                  ? Color(0xffE24F4F)
                                  : Color(0xffE24F4F).withOpacity(0.25),
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                            child: Text(
                              'Update data',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFullNameInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: TextFormField(
        keyboardType: TextInputType.name,
        validator: (value) {
          print(value);
          return nameValidator(value!);
        },
        decoration: InputDecoration(
            hintText: 'Full name',
            isDense: true,
            contentPadding: EdgeInsets.all(12),
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
        decoration: InputDecoration(
            hintText: 'Email',
            isDense: true,
            contentPadding: EdgeInsets.all(12),
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
