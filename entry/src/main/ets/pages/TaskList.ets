import { CommonConstants } from '../common/constant/CommonConstant'
import Task from '../model/Task'
import Tasks from '../model/Tasks'
import { TaskItem } from './TaskItem'
import currentTime from '../common/utils/DateLocal'

@Component export
struct TaskList {
  //总进度是否发生变化。 预览用State, 实际：Consume，因为子组件可以变更它
  @Consume totalProgressChanged: boolean //= false
  //是否开启了编辑模式(默认关闭)
  @State isEditMode: boolean = false
  //选中的任务组
  @State selectedTasks: boolean[] = []
  //点击的任务，默认没选中任何任务
  @State clickIndex: number = CommonConstants.DEFAULT_CLICK_INDEX
  @State selectAll: boolean = false //全选
  @Link tasks: Task[]
    //=
  //   [
  //   new Task('task 1999', '16:12', 20),
  //   new Task('task 202', '20:56', 35),
  //   new Task('task xx', '07:37', 90),
  // ] //任务数据。此处3条演示数据； 实际：Link，预览用state
  onAddClick?: () => void //点击新任务按钮的事件（回调）

  build() {
    Column() {
      Row(){ //标题栏， 左侧是文字，右侧是编辑按钮
        Text($r('app.string.sub_goals'))
          .fontSize($r('app.float.secondary_title'))
          .fontWeight(CommonConstants.FONT_WEIGHT_LARGE)
        Blank() //中间空白
        if (this.tasks.length > 0) { //如果有任务，才可以编辑
          //此处是编辑状态代码
          if (this.isEditMode) { //如果处于可编辑状态，有取消/全选
            Text($r('app.string.cancel_button')) //取消按钮
              .operateTextStyle($r('app.color.main_blue'))
              .margin({left:$r('app.float.operate_button_margin')})
              .onClick(() =>{
                this.selectAll = false //全选为否
                this.isEditMode = false
                //根据任务数组，映射一个全部是false的数组
                this.selectedTasks = this.tasks.map(() => false)
                console.log('取消：' + JSON.stringify(this.selectedTasks))
              })
            Text($r('app.string.select_all_button'))
              .operateTextStyle($r('app.color.main_blue'))
              .margin({left: $r('app.float.operate_button_margin')})
            Checkbox() //选择框
              .select(this.selectAll) //是否全选
              .selectedColor($r('app.color.main_blue')) //选中色
              .width(CommonConstants.CHECKBOX_WIDTH)
              .onClick(() => {
                this.selectAll = !this.selectAll //全选状态反转
                //根据任务数组，映射一个全选状态的数组，全部是false或true
                this.selectedTasks = this.tasks.map(() => this.selectAll)
                console.log('全选： ' + this.selectAll + JSON.stringify(this.selectedTasks))
              })
          } else { //不在编辑模式时,显示编辑文字按钮
            Text($r('app.string.edit_button'))
              .operateTextStyle($r('app.color.main_blue'))
              .onClick(() => {
                this.isEditMode = true //启用编辑模式
                this.selectedTasks = this.tasks.map(() => false)  //启用编辑模式时，把选中数组设为全false
              })
          }

        }
      }.width(CommonConstants.FULL_WIDTH)
      .height($r('app.float.history_line_height'))
      .padding({
        left: $r('app.float.list_padding'),
        right: $r('app.float.list_padding_right')
      })

      List({space: CommonConstants.LIST_SPACE}){
        ForEach(this.tasks,(item: Task,index) => {
          ListItem() {
            TaskItem({
              task: item, //任务
              index: index,
              isEditMode: this.isEditMode,
              selectedTasks: this.selectedTasks, //被选中的任务(双向)
              clickIndex: this.clickIndex, //被选中的任务序号(双向)
              selectAll: this.selectAll //加这个全选参数(双向)
            })
          }
        })
      }
      .margin({top: $r('app.float.list_margin_top')})
      .edgeEffect(EdgeEffect.Spring) //边缘动效：回弹
      .width(CommonConstants.FULL_WIDTH)
      .height(CommonConstants.LIST_HEIGHT)

      Blank()
      if (this.isEditMode) {
        Button($r('app.string.delete_button'))
          //如果有选中的任务，则显示为非透明，否则透明
          .opacity(this.isAnyTaskSelected() ? CommonConstants.NO_OPACITY : CommonConstants.OPACITY)
          //如果有选中的任务，按钮有效，否则无效（不可交互：例如点击）
          .enabled(this.isAnyTaskSelected() ? true : false)
          //删除是敏感操作，红色样式
          .operateButtonStyle($r('app.color.main_red'))
          .onClick(() =>{
            this.delSelected()
          })
      } else {
        //新增任务按钮
        Button($r('app.string.add_task'))
          .operateButtonStyle($r('app.color.main_blue'))
          .onClick(() => {
            if (this.onAddClick) {
              this.onAddClick()
            }
          })
      }


    }
    .width(CommonConstants.MAIN_BOARD_WIDTH)
    .height(CommonConstants.FULL_HEIGHT)
    .padding({top: $r('app.float.operate_row_margin')})
  }


  delSelected(){ //删除选中任务，并重置选中状态
    Tasks.del(this.selectedTasks) //删除选中的任务
    this.tasks = Tasks.allData //重新获取全部任务
    //总进度状态发生变化
    this.totalProgressChanged = !this.totalProgressChanged
    this.isEditMode = false //删除后退出编辑模式
    //选中任务全部清空（重置）
    this.selectedTasks = this.tasks.map(() => false)
    this.selectAll = false //取消全部选中
  }

  isAnyTaskSelected() {
    return this.selectedTasks.filter((selected) => selected === true).length > 0
  }
}

//"可互动的"按钮样式
@Extend(Button) function operateButtonStyle(color: Resource){
  .fontSize($r('app.float.button_font'))
  .fontColor(color)
  .fontWeight(CommonConstants.FONT_WEIGHT)
  .width($r('app.float.button_width'))
  .height($r('app.float.button_height'))
  .backgroundColor($r('app.color.button_background'))
}


//"可互动的"文字样式
@Extend(Text) function operateTextStyle(color: Resource){
  .fontSize($r('app.float.text_button_font'))
  .fontColor(color)
  .lineHeight($r('app.float.text_line_height'))
  .fontWeight(CommonConstants.FONT_WEIGHT)
}