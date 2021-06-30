import 'package:zk_form_g/models/data.dart';

import 'form_row.dart';

List formValidationErrors(List<TFormRow> rows, List<ZkFormData> data) {
  List errors = [];
  rows.forEach((TFormRow row) {
    if (row.validator != null) {
      final index = data.indexWhere((e) => e.tag == row.tag);
      if (index != -1) {
        row.value = data[index].value;
        bool isSuccess = row.validator!(row);
        if (!isSuccess) {
          errors.add(row.requireMsg ?? "${row.title.replaceAll("*", "")} 不能为空");
        }
      }
    } else {
      if (row.require) {
        if (row.value.length == 0) {
          errors.add(row.requireMsg ?? "${row.title.replaceAll("*", "")} 不能为空");
        }
      }
    }
  });
  return errors;
}
