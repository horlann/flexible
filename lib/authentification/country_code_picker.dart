import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';

class CountryCodePickerWidegt extends StatefulWidget {
  const CountryCodePickerWidegt({
    Key? key,
    required this.onChange,
    required this.focusNode,
  }) : super(key: key);

  final Function(String code) onChange;
  final FocusNode focusNode;

  @override
  _CountryCodePickerWidegtState createState() =>
      _CountryCodePickerWidegtState();
}

class _CountryCodePickerWidegtState extends State<CountryCodePickerWidegt> {
  String isoCode = 'GB';

  var prefixTapped = false;
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      if (widget.focusNode.hasFocus & prefixTapped) widget.focusNode.unfocus();
      prefixTapped = false;
    });

    updateIsoCode();
  }

  // Load iso code by sim card
  updateIsoCode() async {
    var _isoCode = (await FlutterSimCountryCode.simCountryCode) ?? 'GB';

    widget.onChange(
        '+' + CountryPickerUtils.getCountryByIsoCode(_isoCode).phoneCode);

    setState(() {
      isoCode = _isoCode;
    });
  }

  void _openCountryPickerDialog(BuildContext context) => showDialog(
        context: context,
        builder: (context) => Theme(
            data: Theme.of(context).copyWith(primaryColor: Colors.pink),
            child: CountryPickerDialog(
              titlePadding: EdgeInsets.all(8.0),
              searchCursorColor: Colors.pinkAccent,
              isSearchable: true,
              title: Text('Select your phone code'),
              onValuePicked: (Country country) {
                setState(() {
                  isoCode = country.isoCode;
                  widget.onChange('+' + country.phoneCode);
                });
              },
              // itemFilter: (c) => ['AR', 'DE', 'GB', 'CN'].contains(c.isoCode),
              priorityList: [
                CountryPickerUtils.getCountryByIsoCode('TR'),
                CountryPickerUtils.getCountryByIsoCode('US'),
              ],
            )),
      );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        prefixTapped = true;
        widget.focusNode.unfocus();
        _openCountryPickerDialog(context);
      },
      child: Text(
          '+' + CountryPickerUtils.getCountryByIsoCode(isoCode).phoneCode,
          style: TextStyle(fontSize: 10 * byWithScale(context))),
    );
  }
}