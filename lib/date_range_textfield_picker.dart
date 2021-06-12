library date_range_textfield_picker;

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget datePicker(BuildContext context,{required TextEditingController controller,
  String? dateLabelText,
  Locale? locale,
  DateTime? firstDate,
  DateTime? lastDate,
  void Function(String)? onChanged,
  bool Function(DateTime)? selectableDayPredicate,
}) {
  return DateTimePicker(
    type: DateTimePickerType.date,
    dateMask: 'yyyy-MM-dd',
    firstDate: firstDate??DateTime.fromMillisecondsSinceEpoch(0),
    lastDate: lastDate??DateTime.parse('3100-12-13'),
    controller: controller,
    icon: Icon(Icons.event),
    dateLabelText: dateLabelText??'Date',
    locale: locale,
    selectableDayPredicate: selectableDayPredicate,
    onChanged: onChanged,
    validator: (str){
      return (str!=""&&str!=null)?null:"wrong";
    },
  );
}

class DateRangeTextFieldPickerForm extends StatefulWidget{
  DateRangeTextFieldPickerForm({
    this.firstDate,
    this.lastDate,
    this.selectableDayPredicate,
    this.startLabelText,
    this.endLabelText,
    this.locale,
    required this.startDateController,
    required this.endDateController,
    required this.formKey,
  });


  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool Function(DateTime)? selectableDayPredicate;
  final String? startLabelText;
  final String? endLabelText;
  final Locale? locale;
  final TextEditingController startDateController;
  final TextEditingController endDateController;
  final GlobalKey<FormState> formKey;
  @override
  _DateRangeTextFieldPickerFormState createState() => _DateRangeTextFieldPickerFormState();

}

class _DateRangeTextFieldPickerFormState extends State<DateRangeTextFieldPickerForm>{
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,child:Column(
        children:[
          datePicker(context,
              firstDate: widget.firstDate,
              lastDate:widget.lastDate,
              locale:widget.locale,
              selectableDayPredicate: widget.selectableDayPredicate,
              controller: widget.startDateController,
              dateLabelText: widget.startLabelText,
              onChanged: (String str){
                var start=DateTime.parse(str);
                var end=DateTime.tryParse(widget.endDateController.text);
                if(end!=null){
                  if(start.isAfter(end)){
                    setState(() {
                      widget.endDateController.text=str;
                    });
                  }
                }
              }
          ),
          datePicker(context,
              firstDate: widget.firstDate,
              lastDate:widget.lastDate,
              locale:widget.locale,
              selectableDayPredicate: widget.selectableDayPredicate,
              controller: widget.endDateController,
              dateLabelText: widget.endLabelText,
              onChanged: (String str){
                var start=DateTime.tryParse(widget.startDateController.text);
                var end=DateTime.parse(str);
                if(start!=null){
                  if(start.isAfter(end)){
                    setState(() {
                      widget.startDateController.text=str;
                    });
                  }
                }
              }
          ),
        ]
    ),
    );
  }


}


Future<DateTimeRange?> showDateRangeTextFieldPicker({required BuildContext context,String? title,DateTime? firstDate,
  DateTime? lastDate,bool Function(DateTime)? selectableDayPredicate,
  String? startLabelText,
  String? endLabelText,
  String? confirmLabelText,
  Locale? locale,
  String? cancelLabelText,
})async{
  var startDateController=TextEditingController();
  var endDateController=TextEditingController();
  var screenWidth=MediaQuery.of(context).size.width;
  //var screenHeight=MediaQuery.of(context).size.height;
  GlobalKey<FormState> _oFormKey = GlobalKey<FormState>();
  var dR=await showDialog<DateTimeRange>(context: context,
      barrierDismissible: true,
      builder: (context) => WillPopScope(
      onWillPop: ()async {
        return true;
      },
      child:AlertDialog(
        title: Text(title??'Choose date range'),
        contentPadding: EdgeInsets.symmetric(horizontal: 25,vertical: 10),
        content: Container(
          width: screenWidth * 0.7,
          height: screenWidth * 0.7*0.55,
            child: DateRangeTextFieldPickerForm(
              formKey: _oFormKey,
              endDateController: endDateController,
              startDateController: startDateController,
              firstDate:firstDate,
              lastDate:lastDate,
              selectableDayPredicate:selectableDayPredicate,
              startLabelText:startLabelText,
              endLabelText:endLabelText,
              locale:locale,
            )
        ),
        actions: [
          TextButton(
            /*style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith(
                    (state) => AppTheme.chipBackground)),*/
            onPressed: () => Navigator.pop(context),
            child: Text(cancelLabelText??'Cancel'),
          ),
          TextButton(
            /*style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith(
                    (state) => AppTheme.chipBackground)),*/
            onPressed: (){
              DateTimeRange? dR;
              final loForm = _oFormKey.currentState;
              if (loForm?.validate() == true) {
                dR=DateTimeRange(start: DateTime.parse(startDateController.text),
                    end: DateTime.parse(endDateController.text));
              }
              Navigator.pop(context,dR);
            },
            child: Text(confirmLabelText??'Save'),
          ),
        ]
      )
    )
  );
  return dR;
}
