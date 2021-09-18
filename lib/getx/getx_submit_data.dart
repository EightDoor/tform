import 'package:get/get.dart';
import 'package:zk_form_g/models/data.dart';

// 提交数据
class SubmitDataController extends GetxController {
  // 修改的值
  late RxList<Map<String, dynamic>> list = RxList<Map<String, dynamic>>([]);
  // 传递的原始数据值
  late RxList<ZkFormData> sourceData = RxList<ZkFormData>([]);

  // 设置修改值
  void setData(List<Map<String, dynamic>> data) {
    list = RxList<Map<String, dynamic>>([]);
    data.forEach((e) {
      list.add(e);
    });
    update();
  }

  // 设置原始值
  void setSourceData(List<ZkFormData> data) {
    sourceData = RxList<ZkFormData>([]);
    data.forEach((e) {
      sourceData.add(e);
    });
    update();
  }

  // 更新某一项值
  void updateSingData(String tag, String val) {
    List<ZkFormData> result = RxList<ZkFormData>([]);
    result = sourceData.map((e) {
      if(tag == e.tag) {
        e.value = val;
      }
      return e;
    }).toList();
    print(result);
    sourceData = result.obs;
  }
}
