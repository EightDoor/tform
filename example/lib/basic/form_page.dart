import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:zk_form_g/models/data.dart';
import 'package:zk_form_g/tform.dart';

import '../utils.dart';
import '../widgets/verifitionc_code_button.dart';

class FormPage extends StatefulWidget {
  FormPage({Key key}) : super(key: key);
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final GlobalKey _formKey = GlobalKey<TFormState>();
  final String test = "测试文本";
  List<Map<String, dynamic>> sourceList = [
    {
      "tag": "name",
      "value": "周凯",
    },
    {
      "tag": "card",
      "value": "1528251994898989",
    },
    {
      "tag": "phone1",
      "value": "13904785187",
    },
    {
      "tag": "yz",
      "value": "8989",
    },
    {
      "tag": "education",
      "value": "本科",
    },
    {
      "tag": "selectStr",
      "value": "1",
    }
  ];
  List<ZkFormData> list = [];
  @override
  void initState() {
    sourceList.forEach((e) {
      list.add(
        ZkFormData.fromJson(e),
      );
    });
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("表单"),
        actions: [
          TextButton(
            child: Text(
              "提交",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            onPressed: () {
              //校验
              List errors = (_formKey.currentState as TFormState).validate();
              if (errors.isNotEmpty) {
                showToast(errors.first);
                return;
              }
              List<ZkFormData> list =
                  (_formKey.currentState as TFormState).submitData();
              list.forEach((e) {
                print(e.toJson());
              });
              //通过
              showToast("提交成功");
            },
          ),
        ],
      ),
      body: TForm.builder(
        key: _formKey,
        sourceData: list,
        listType: TFormListType.column,
        rows: buildFormRows(test),
        divider: Divider(
          height: 1,
        ),
      ),
    );
  }
}

List<TFormRow> buildFormRows(String test) {
  return [
    TFormRow.input(
      title: "姓名",
      tag: "name",
      placeholder: "请输入姓名",
    ),
    TFormRow.input(
      tag: "card",
      enabled: false,
      requireStar: true,
      title: "身份证号",
      placeholder: "请输入身份证号",
    ),
    TFormRow.input(
      tag: "card",
      enabled: false,
      requireStar: true,
      title: "身份证号",
      placeholder: "请输入身份证号",
    ),
    TFormRow.input(
      tag: "card",
      enabled: false,
      requireStar: true,
      title: "身份证号",
      placeholder: "请输入身份证号",
    ),
    TFormRow.input(
      tag: "card",
      enabled: false,
      requireStar: true,
      title: "身份证号",
      placeholder: "请输入身份证号",
    ),
    TFormRow.input(
      tag: "card",
      enabled: false,
      requireStar: true,
      title: "身份证号",
      placeholder: "请输入身份证号",
    ),
    TFormRow.input(
      tag: "card",
      enabled: false,
      requireStar: true,
      title: "身份证号",
      placeholder: "请输入身份证号",
    ),
    TFormRow.input(
      tag: "phone1",
      keyboardType: TextInputType.number,
      title: "预留手机号",
      placeholder: "请输入手机号",
      requireMsg: "请输入正确的手机号",
      requireStar: true,
      require: true,
      textAlign: TextAlign.right,
      validator: (row) {
        return RegExp(
                r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$')
            .hasMatch(row.value);
      },
    ),
    TFormRow.input(
      title: "多行文本",
      tag: 'more',
      maxLines: 20,
    ),
    TFormRow.input(
      tag: "yz",
      title: "验证码",
      placeholder: "请输入验证码",
      suffixWidget: (context, row) {
        return VerifitionCodeButton(
          title: "获取验证码",
          seconds: 60,
          onPressed: () {
            showToast("验证码已发送");
          },
        );
      },
    ),
    TFormRow.input(
      tag: "password",
      title: "* 密码",
      obscureText: true,
      state: false,
      placeholder: "请输入密码",
      suffixWidget: (context, row) {
        return GestureDetector(
          onTap: () {
            row.state = !row.state;
            row.obscureText = !row.obscureText;
            TForm.of(context).reload();
          },
          child: Image.asset(
            row.state ? "lib/src/eyes_open.png" : "lib/src/eyes_close.png",
            width: 20,
            height: 20,
          ),
        );
      },
    ),
    TFormRow.customSelector(
      tag: "marriage",
      title: "婚姻状况",
      placeholder: "请选择",
      state: [
        ["未婚", "已婚"],
        [
          TFormRow.input(
              title: "配偶姓名", placeholder: "请输入配偶姓名", requireStar: true),
          TFormRow.input(
              title: "配偶电话", placeholder: "请输入配偶电话", requireStar: true)
        ]
      ],
      onTap: (context, row) async {
        String value = await showPicker(row.state[0], context);
        if (row.value != value) {
          if (value == "已婚") {
            TForm.of(context).insert(row, row.state[1]);
          } else {
            TForm.of(context).delete(row.state[1]);
          }
        }
        return value;
      },
    ),
    TFormRow.selector(
      tag: 'education',
      title: "学历",
      placeholder: "请选择",
      options: [
        '专科',
        "本科",
        "硕士",
      ],
    ),
    TFormRow.selector(
      tag: 'selectStr',
      title: "选择项为 value label",
      placeholder: "请选择",
      options: [
        {"value": "1", "label": "本科"},
        {"value": "2", "label": "专科"},
      ],
    ),
    TFormRow.multipleSelector(
      title: "家庭成员",
      placeholder: "请选择",
      options: [
        TFormOptionModel(value: "父亲", selected: false),
        TFormOptionModel(value: "母亲", selected: false),
        TFormOptionModel(value: "儿子", selected: false),
        TFormOptionModel(value: "女儿", selected: false)
      ],
    ),
    TFormRow.timeSelect(
      title: "开始时间",
      placeholder: "请选择",
      tag: "startTime",
      mode: DateMode.YMDHMS,
    ),
    TFormRow.customSelector(
      title: "出生年月",
      placeholder: "请选择",
      onTap: (context, row) async {
        return showPickerDate(context);
      },
      fieldConfig: TFormFieldConfig(
        selectorIcon: SizedBox.shrink(),
      ),
    ),
    TFormRow.customCell(
      widget: Container(
          color: Colors.grey[200],
          height: 48,
          width: double.infinity,
          alignment: Alignment.center,
          child: Text("------ 我是自定义的Cell ------")),
    ),
    TFormRow.customCell(
      widget: Container(
        child: Text(
          test,
        ),
      ),
    )
    // TFormRow.customCellBuilder(
    //   title: "房屋照片",
    //   state: [
    //     {"picurl": ""},
    //     {"picurl": ""},
    //     {"picurl": ""},
    //     {"picurl": ""},
    //     {"picurl": ""},
    //   ],
    //   requireMsg: "请完成上传房屋照片",
    //   validator: (row) {
    //     bool suc = (row.state as List)
    //         .every((element) => (element["picurl"].length > 0));
    //     if (!suc) {
    //       row.requireMsg = "请完成${row.title}上传";
    //     }
    //     return suc;
    //   },
    //   widgetBuilder: (context, row) {
    //     return CustomPhotosWidget(row: row);
    //   },
    // ),
  ];
}
