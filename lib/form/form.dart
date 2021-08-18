import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zk_form_g/getx/getx_submit_data.dart';
import 'package:zk_form_g/models/data.dart';

import 'form_cell.dart';
import 'form_row.dart';
import 'form_validation.dart';

enum TFormListType { column, sliver, builder, separated }

class TForm extends StatefulWidget {
  final List<TFormRow> rows;
  final TFormListType listType;
  final Divider divider;
  final List<ZkFormData>? sourceData;

  TForm({
    required Key key,
    required this.rows,
    this.listType = TFormListType.column,
    required this.divider,
    this.sourceData,
  }) : super(key: key);

  TForm.column({
    required Key key,
    required this.rows,
    this.listType = TFormListType.sliver,
    required this.divider,
    this.sourceData,
  }) : super(key: key);

  TForm.sliver({
    required Key key,
    required this.rows,
    this.listType = TFormListType.sliver,
    required this.divider,
    this.sourceData,
  }) : super(key: key);

  TForm.builder({
    required Key key,
    required this.rows,
    this.listType = TFormListType.builder,
    required this.divider,
    this.sourceData,
  }) : super(key: key);

  /// 注意 of 方法获取的是 TFormState
  static TFormState of(BuildContext context) {
    final _TFormScope scope =
        context.dependOnInheritedWidgetOfExactType<_TFormScope>()!;
    return scope.state;
  }

  @override
  TFormState createState() => TFormState(rows);
}

class TFormState extends State<TForm> {
  SubmitDataController _logc = Get.put(
    SubmitDataController(),
  );

  List<TFormRow> rows;
  List<Map<String, dynamic>> list = [];
  get form => widget;
  get divider => widget.divider;

  TFormState(this.rows);
  @override
  void initState() {
    _logc.setSourceData(
      widget.sourceData ?? [],
    );
    super.initState();
  }

  @override
  void dispose() {
    _logc.setSourceData([]);
    _logc.setData([]);
    super.dispose();
  }

  /// 表单插入，可以是单个 row，也可以使一组 rows
  void insert(currentRow, item) {
    if (item is List<TFormRow>) {
      rows.insertAll(rows.indexOf(currentRow) + 1,
          item.map((e) => e..animation = true).toList());
    } else if (item is TFormRow) {
      rows.insert(rows.indexOf(currentRow), item..animation = true);
    }
    reload();
  }

  /// 表单删除，可以是单个 row，也可以使一组 rows
  void delete(item) {
    if (item is List<TFormRow>) {
      item.forEach((element) {
        rows.remove(element);
      });
    } else if (item is TFormRow) {
      rows.remove(item);
    }
    reload();
  }

  /// 更新表单
  void reload() {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      rows = [...rows];
    });
  }

  /// 验证表单
  List validate() {
    FocusScope.of(context).requestFocus(FocusNode());
    List errors = formValidationErrors(rows, widget.sourceData ?? []);
    return errors;
  }

  /// 返回表单项值
  List<ZkFormData> submitData() {
    List<ZkFormData> result = [];
    List<Map<String, dynamic>> data = _logc.list.value;
    List<ZkFormData> sourceData = _logc.sourceData.value;
    // 处理传入的原始值
    sourceData.forEach((e) {
      int index = data.indexWhere((v) => v['tag'] == e.tag);
      if (index != -1) {
        e.value = data[index]['value'];
      }
      result.add(
        e,
      );
    });

    // 找出新增的值
    data.forEach((e) {
      final int index = sourceData.indexWhere(
        (v) => v.tag == e['tag'],
      );
      if (index == -1) {
        result.add(
          ZkFormData.fromJson(e),
        );
      }
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return _TFormScope(
      state: this,
      child: TFormList(
        type: widget.listType,
      ),
    );
  }
}

class _TFormScope extends InheritedWidget {
  const _TFormScope({
    Key? key,
    required Widget child,
    required this.state,
  }) : super(key: key, child: child);

  final TFormState state;
  get rows => state.rows;

  @override
  bool updateShouldNotify(_TFormScope old) => rows != old.rows;
}

class TFormList extends StatelessWidget {
  const TFormList({Key? key, required this.type}) : super(key: key);

  final TFormListType type;

  @override
  Widget build(BuildContext context) {
    final rows = TForm.of(context).rows;
    Widget list = Container();
    switch (type) {
      case TFormListType.column:
        list = GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: SingleChildScrollView(
            child: Column(
              children: rows.map((e) {
                return TFormCell(row: e);
              }).toList(),
            ),
          ),
        );
        break;
      case TFormListType.sliver:
        list = SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
          return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: TFormCell(row: rows[index]));
        }, childCount: rows.length));
        break;
      case TFormListType.builder:
        list = GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: ListView.builder(
            itemCount: rows.length,
            itemBuilder: (BuildContext context, int index) {
              return TFormCell(row: rows[index]);
            },
          ),
        );
        break;
      default:
    }
    return list;
  }
}
