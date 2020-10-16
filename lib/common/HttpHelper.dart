
import 'package:provider/provider.dart';
import 'package:tuangechezs/http/index.dart';
import 'package:tuangechezs/provider/TaskEvent.dart';

import 'Unit.dart';

class HttpHelper{
  /// title 浏览数据标题 dataId 浏览数据ID type 4软文、5视频
  static saveFootprint(title,dataId,type,context) {
    HttpUtlis.post("third/user/saveFootprint",
        params: {'title': title, 'dataId': dataId, 'type': type},
        success: (value) async {
          if (value['errno'] == 0) {
            //任务数据刷新
            final taskCounter = Provider.of<TaskEvent>(context);
            taskCounter.increment(true);
          }
        }, failure: (error) {
          Unit.setToast(error, context);
        });
  }
}