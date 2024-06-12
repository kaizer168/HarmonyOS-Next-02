import { CommonConstants } from '../common/constant/CommonConstant'
import currentTime from '../common/utils/DateLocal'
import Task from '../model/Task'
import Tasks from '../model/Tasks'
import { promptAction } from '@kit.ArkUI'
import AddTask from './AddTask'
import { TaskOverview } from './TaskOverview'
import { TaskList } from './TaskList'

@Entry
@Component
struct Home {
  @State tasks: Task[] = Tasks.allData //任务组
  @State total: number = 0 //任务数
  @State finish: number = 0 //完成数
  //最新更新
  @State latestUpdate: string = CommonConstants.DEFAULT_PROGRESS_VALUE
  //总进度
  @Provide @Watch('onProgressChanged') totalProgressChanged: boolean = false

  //新增任务对话框控制器
  dialogController = new CustomDialogController({
    builder: AddTask({
      //确认按钮的回调： 将输入框的值，保存为新任务
      onConfirm:  (value): void => this.saveTask(value)
    }),
    alignment: DialogAlignment.Bottom, //显示在底部
    offset: { //x,y轴的相对偏移
      dx: CommonConstants.DIALOG_OFFSET_X, //0
      dy: $r('app.float.dialog_offset_y')
    },
    customStyle: true, //自定义样式
    autoCancel: false //自动取消：否
  })


  //当总进度发生变化时
  onProgressChanged(){
    this.total = this.tasks.length //更新总任务数
    this.finish = this.tasks.filter((task) => {
      return task.progress == CommonConstants.SLIDER_MAX_VALUE
    }).length //筛选任务组中进度为最大值（100）的数目
    this.latestUpdate = currentTime() //使用当前时间
  }

  //保存新增的任务
  saveTask(name: string){
    if (name === '') { //如果任务名是空
      promptAction.showToast({ //弹出提示提醒用户
        message: $r('app.string.cannot_input_empty'),
        duration: CommonConstants.TOAST_TIME,
        bottom: CommonConstants.TOAST_MARGIN_BOTTOM //底边距
      })
      return //退出保存
    }

    Tasks.add(new Task(name, currentTime(),0)) //增加一条任务
    this.tasks = Tasks.allData //再获取任务组
    //总进度变化
    this.totalProgressChanged = !this.totalProgressChanged
    //关闭对话框
    this.dialogController.close()
  }

  @Builder titleBar(){ //标题栏，写在Build方法外
    Text($r('app.string.title'))
      .width(CommonConstants.TITLE_WIDTH)
      .height($r('app.float.title_height'))
      .fontSize($r('app.float.title_font'))
      .fontWeight(CommonConstants.FONT_WEIGHT_LARGE)
      .textAlign(TextAlign.Start)
      .margin({
        top: $r('app.float.title_margin'),
        bottom: $r('app.float.title_margin')
      })
  }


  build() {
    Column() { //首页根容器，列
      this.titleBar() //标题栏
      TaskOverview({ //任务概览
        latestUpdate: this.latestUpdate,
        total: this.total,
        finish: this.finish
      })
      TaskList({
        tasks: $tasks, //任务组，双向同步
        onAddClick: (): void => this.dialogController.open()
      })
        //list高度限制
        .height('55%')
    }
    .backgroundColor($r('app.color.index_background'))
    .height(CommonConstants.FULL_HEIGHT)
    .width(CommonConstants.FULL_WIDTH)
  }
}