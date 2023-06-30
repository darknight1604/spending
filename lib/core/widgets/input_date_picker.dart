import 'package:dani/core/constants.dart';
import 'package:dani/core/utils/extensions/date_time_extension.dart';
import 'package:dani/core/utils/text_theme_util.dart';
import 'package:flutter/material.dart';

class InputDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final ValueChanged<DateTime> onSubmit;
  const InputDatePicker({
    required this.onSubmit,
    this.initialDate,
  });

  @override
  State<InputDatePicker> createState() => _InputDatePickerState();
}

class _InputDatePickerState extends State<InputDatePicker> {
  late DateTime _dateSelected;

  @override
  void initState() {
    super.initState();
    _dateSelected = widget.initialDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        DateTime? temp = await showDatePicker(
          context: context,
          initialDate: _dateSelected,
          firstDate: DateTime(2023, DateTime.january, 1),
          lastDate: DateTime(2023, DateTime.december, 31),
        );
        if (temp == null) return;
        setState(() {
          _dateSelected = temp;
          widget.onSubmit(_dateSelected);
        });
      },
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Constants.borderColor),
          borderRadius: BorderRadius.circular(Constants.radius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(
                Icons.date_range_outlined,
                size: Constants.iconSize,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(
                width: Constants.padding,
              ),
              Expanded(
                child: Text(
                  _dateSelected.formatDDMMYYYY(),
                  style: TextThemeUtil.instance.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
