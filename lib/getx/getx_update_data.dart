import 'package:get/get.dart';
import 'package:zk_form_g/models/data.dart';

/// 手动变更值触发的更新
class GetxUpdateData {
  static var data = <ZkFormData>[].obs;
  static void setValue(List<ZkFormData> list) {
    data.value = list;
  }
}
