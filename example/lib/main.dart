import 'package:date_range_textfield_picker/date_range_textfield_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter DateTimePicker Demo',
      home: MyHomePage(),
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('en', 'US'),Locale('zh','TW')],
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<FormState> _oFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter DateRangeTextFieldPicker Demo'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Form(
          key: _oFormKey,
          child: Column(
            children: <Widget>[
              Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              ElevatedButton(
                onPressed: () async{
                  var dR=await showDateRangeTextFieldPicker(context: context,title:"選擇時間範圍",firstDate: DateTime.parse("2000-01-01"),
                      lastDate: DateTime.parse("2050-01-01"),
                      startLabelText: "開始日期", endLabelText: "結束日期",confirmLabelText: "確定",
                      cancelLabelText: "取消",locale:Locale("zh","TW"),
                      initialEndDate: DateTime.now(),
                  );
                  print(dR);
                },
                child: Text('Choose Date Range'),
              ),
            ],
          ),
      ]),
    )));
  }
}
