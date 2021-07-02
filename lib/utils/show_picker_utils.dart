import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';
import 'package:flutter_pickers/time_picker/model/suffix.dart';

/// 输入
typedef FormCallBackItem = Function(String val);

var selectData = {
  DateMode.YMDHMS: '',
  DateMode.YMDHM: '',
  DateMode.YMDH: '',
  DateMode.YMD: '',
  DateMode.YM: '',
  DateMode.Y: '',
  DateMode.MDHMS: '',
  DateMode.HMS: '',
  DateMode.MD: '',
  DateMode.S: '',
};

PickerStyle pickerStyle(Widget title) {
  return PickerStyle(
    headDecoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(1),
      ),
    ),
    commitButton: Padding(
      padding: EdgeInsets.only(right: 15),
      child: title,
    ),
  );
}

/// 选择框
class ShowPickerUtils {
  // 单个数据选择
  static void showSingPicker(
      {required BuildContext context,
      required List<Map<String, dynamic>> sourceList,
      String? selectLabel,
      required FormCallBackItem callResult,
      FormCallBackItem? callChange}) {
    selectLabel = selectLabel ?? "请选择";
    List<String> _list = [];
    sourceList.forEach((e) {
      _list.add(e['label']);
    });
    Pickers.showSinglePicker(
      context,
      pickerStyle: pickerStyle(
        Text("确定"),
      ),
      data: _list,
      selectData: selectLabel,
      onConfirm: (p, position) {
        String result = ShowPickerUtils.formatValue(p, sourceList);
        print('当前选择的: ' + result);
        callResult(result);
      },
      onChanged: (p, position) {
        if (callChange != null) {
          callChange(p);
        }
      },
    );
  }

  static String formatValue(String label, list) {
    var result = list.firstWhere((e) => e["label"] == label);
    if (result.isNotEmpty) {
      print('当前选择的: select -> ' + result.toString());
      return result['value'];
    }
    return "选择框数据没有找到";
  }

  static void showTimePicker({
    required BuildContext context,
    DateMode mode = DateMode.YMD,
    Suffix? suffix,
    PDuration? selectDate,
    PDuration? minDate,
    PDuration? maxDate,
    required FormCallBackItem callBackItem,
    FormCallBackItem? callBackChange,
  }) {
    // selectDate: PDuration(hour: 18, minute: 36, second: 36),
    // minDate: PDuration(hour: 12, minute: 38, second: 3),
    // maxDate: PDuration(hour: 12, minute: 40, second: 36),
    Pickers.showDatePicker(
      context,
      mode: mode,
      pickerStyle: pickerStyle(
        Text("确定"),
      ),
      suffix: suffix,
      selectDate: selectDate,
      minDate: minDate,
      onChanged: (p) {
        if (callBackChange != null) {
          callBackChange(ShowPickerUtils.formatModel(p, mode)!);
        }
      },
      maxDate: maxDate,
      onConfirm: (p) {
        print(
          '当前选择的日期: ' + ShowPickerUtils.formatModel(p, mode).toString(),
        );
        callBackItem(
          ShowPickerUtils.formatModel(p, mode)!,
        );
      },
    );
  }

  static String hourFormat(int val) {
    if (val < 10) {
      return "0$val";
    } else {
      return val.toString();
    }
  }

  // 格式化选择时间
  static String? formatModel(PDuration p, DateMode modeS) {
    switch (modeS) {
      case DateMode.YMDHMS:
        selectData[modeS] =
            '${p.year}-${hourFormat(p.month!)}-${hourFormat(p.day!)} ${hourFormat(p.hour!)}:${hourFormat(p.minute!)}:${hourFormat(p.second!)}';
        break;
      case DateMode.YMDHM:
        selectData[modeS] =
            '${p.year}-${hourFormat(p.month!)}-${hourFormat(p.day!)} ${hourFormat(p.hour!)}:${hourFormat(p.minute!)}';
        break;
      case DateMode.YMDH:
        selectData[modeS] =
            '${p.year}-${hourFormat(p.month!)}-${hourFormat(p.day!)} ${hourFormat(p.hour!)}';
        break;
      case DateMode.YMD:
        selectData[modeS] =
            '${p.year}-${hourFormat(p.month!)}-${hourFormat(p.day!)}';
        break;
      case DateMode.YM:
        selectData[modeS] = '${p.year}-${hourFormat(p.month!)}';
        break;
      case DateMode.Y:
        selectData[modeS] = '${p.year}';
        break;
      case DateMode.MDHMS:
        selectData[modeS] =
            '${hourFormat(p.month!)}-${hourFormat(p.day!)} ${hourFormat(p.hour!)}:${hourFormat(p.minute!)}:${hourFormat(p.second!)}';
        break;
      case DateMode.HMS:
        selectData[modeS] =
            '${hourFormat(p.hour!)}:${hourFormat(p.minute!)}:${hourFormat(p.second!)}';
        break;
      case DateMode.MD:
        selectData[modeS] = '${hourFormat(p.month!)}-${hourFormat(p.day!)}';
        break;
      case DateMode.S:
        selectData[modeS] = '${hourFormat(p.second!)}';
        break;
      case DateMode.H:
        selectData[modeS] = '${hourFormat(p.hour!)}';
        break;
      default:
        selectData[modeS] =
            '${p.year}-${hourFormat(p.month!)}-${hourFormat(p.day!)} ${hourFormat(p.hour!)}:${hourFormat(p.minute!)}:${hourFormat(p.second!)}';
    }
    return selectData[modeS];
  }
}
