import Logger from '../common/utils/Logger'
import currentTime from  '../common/utils/DateLocal'
import AddTask from  './AddTask'
import Tasks from '../model/Tasks';
import Task from '../model/Task';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State message: string = '添加任务'
  @State tasks: Task[] = Tasks.allData

  dialogController = new CustomDialogController({
    builder: AddTask({
      onConfirm: (value) => {
        Logger.debug('首页', value)
        // Tasks.add(new Task(value,currentTime(), 0))
        this.dialogController.close()
      }
    }),
    alignment: DialogAlignment.Bottom,
    customStyle: true,
    autoCancel: false,
    offset: {dx: 0,dy: -20}
  });

  build() {

      Column() {
        Text(`新任务。\n总数：${this.tasks.length}`)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() =>{
            Logger.debug('首页', currentTime())
            // this.dialogController.open()
            Tasks.add(new Task('哈哈',currentTime(), 0))
          })
        Blank()

        Text('到新页')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() =>{
            router.pushUrl({
              url: 'pages/Page22'
            })
          })
      }
      .width('100%')
      .height('100%')


  }
}