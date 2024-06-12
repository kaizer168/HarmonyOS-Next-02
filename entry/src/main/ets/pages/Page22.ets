import Task from '../model/Task';
import Tasks from '../model/Tasks';

@Entry
@Component
struct Page22 {
  @State message: string = 'Hello World';
  @State tasks : Task[] = Tasks.allData

  build() {
    Row() {
      Column() {
        Text(this.tasks.length.toString())
          .fontSize(50)
          .fontWeight(FontWeight.Bold)

      }
      .width('100%')
    }
    .height('100%')
  }
}