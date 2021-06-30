class ZkFormData {
  String tag = '';
  String value = '';

  ZkFormData({required this.tag, required this.value});

  ZkFormData.fromJson(Map<String, dynamic> json) {
    tag = json['tag'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tag'] = this.tag;
    data['value'] = this.value;
    return data;
  }
}
