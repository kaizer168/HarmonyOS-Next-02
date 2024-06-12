import { CommonConstants } from '../common/constant/CommonConstant'
import currentTime from '../common/utils/DateLocal'
import Task from '../model/Task'
import Tasks from '../model/Tasks'
import { ProgressEdit } from './ProgressEdit'

@Extend(Text)  function opacityTextStyle(){
  .fontSize($r('app.float.text_font'))
  .fontColor($r('app.color.title_black_color'))
  .opacity(CommonConstants.OPACITY)
  .fontWeight(CommonConstants.FONT_WEIGHT)
}

@Component export
struct TaskItem {
  // 当前的任务；给一个默认值，方便调试
  @State task: Task = new Task('task 1', currentTime(),10)

  //当前任务的序号
  index = 0

  //总进度是否发生变化，需要回传，来自最上层Provide。 预览用State
  @Consume totalProgressChanged: boolean //= false

  //选中的任务组，来自上级，如果更新需回传（@link）;为了调试方便，暂用@state
  @Link selectedTasks : boolean[]  //= []

  //是否开启了编辑模式，由上级组件决定
  @Prop isEditMode: boolean = true

  //展开进度面板
  @State isExpanded : boolean = true
  //进度面板滑动模式
  @State mode: number = CommonConstants.DEFAULT_SLIDER_MODE


  //点击的任务，保存其序号并回传（@link）;为了调试方便，暂用@state
  //并且监听点击，@Watch，处理函数changeIndex
  @Link @Watch('onClickIndex') clickIndex: number //= 0

  //索引点击监听器：如果点击的不是当前任务，则折叠进度编辑面板。
  onClickIndex(){
    if (this.clickIndex !== this.index) {
      this.isExpanded == false
    }
  }

  //最新进度
  @State latestProgress: number = 0
  //更新日期
  @State updateDate?: string = ''

  @Link selectAll: boolean

  //页面即将显示
  aboutToAppear(): void {
    this.latestProgress = this.task.progress
    this.updateDate = this.task.update
  }

  @Builder TaskInfo() { //任务信息文字栏
    Row(){
      Text(this.task.name) //任务名
        .fontSize($r('app.float.list_font'))
        .fontWeight(CommonConstants.FONT_WEIGHT)
        .fontColor($r('app.color.title_black_color'))
        .width(CommonConstants.TASK_NAME_WIDTH)
        .textAlign(TextAlign.Start)
        .maxLines(CommonConstants.MAX_LINES)
      Blank()
      Column(){ //进度信息
        Text(`${this.latestProgress}%`) //任务进度
          .fontSize($r('app.float.list_font'))
          .fontWeight(CommonConstants.FONT_WEIGHT)
          .fontColor($r('app.color.title_black_color'))

        Row(){
          Text($r('app.string.latest_updateTime')).opacityTextStyle()
          Text(this.updateDate).opacityTextStyle()
        }.margin({top : $r('app.float.text_margin')})
      }.alignItems(HorizontalAlign.End) //列内容居右排列
    }
  }



  build() {
    Stack({alignContent: Alignment.TopEnd}){
      Column() {
        this.TaskInfo()
        if (this.isExpanded) { //如果是展开的话，
          Blank() //列的自动间隔
          ProgressEdit({
            progress: this.latestProgress, //最新进度
            mode: this.mode, //滑动模式
            onCancel: () => this.isExpanded = false, //取消事件: 折叠面板
            onConfirm: (value) => { //确认更新进度后
              this.latestProgress = value //把最新进度设置为滑动后的值
              this.updateDate = currentTime() //使用最新的系统日期更新

              //如果更新指定索引的任务成功
              if (Tasks.updateTo(this.index, this.latestProgress, this.updateDate)) {
                this.totalProgressChanged = !this.totalProgressChanged //整体进度发生了变化


              }
              this.isExpanded = false //更新进度折叠面板
            }
          })//进度面板
            .transition({ //折叠动画
              scale: { //尺寸缩放：收缩成一条线消失
                x: CommonConstants.TRANSITION_ANIMATION_X, //x轴方向为原来1倍
                y: CommonConstants.TRANSITION_ANIMATION_Y //y轴方向为原来0倍
              }
            })
        }
      }
      .height(this.isExpanded ? $r('app.float.expanded_item_height')
        : $r('app.float.list_item_height'))
      .width(CommonConstants.FULL_WIDTH)
      .opacity( //如果进度拉满（100），则整个容器变成半透明状态，否则是不透明
        this.latestProgress === CommonConstants.SLIDER_MAX_VALUE ?
        CommonConstants.OPACITY : CommonConstants.NO_OPACITY
      )
      .borderRadius(CommonConstants.LIST_RADIUS) //单个任务列表的圆角
      .animation({duration: CommonConstants.DURATION}) //属性动画：时长
      .backgroundColor(this.selectedTasks[this.index] ? $r('app.color.edit_blue')
        : Color.White) //背景色：当前任务蓝色
      .onClick(() => { //点击事件处理
        if (this.mode == CommonConstants.CLICK_SLIDER_MODE) { //如果点击的是滑块
          this.mode = CommonConstants.DEFAULT_SLIDER_MODE //滑块事件归位
          return //返回。不继续处理 任务本身容器的点击事件
        }

        if (!this.isEditMode) { //非编辑状态,
          // 显式动画： 折叠/展开效果
          animateTo({duration: CommonConstants.DURATION}, () => {
            this.isExpanded = !this.isExpanded
          })
          this.clickIndex = this.index //点击索引赋值
        }
      })
      .padding({
        top: $r('app.float.list_padding_top'),
        bottom: $r('app.float.list_padding_bottom'),
        left: $r('app.float.list_padding'),
        right: this.isEditMode ? $r('app.float.list_edit_padding') :
        $r('app.float.list_padding') //编辑模式，右边距加大
      })

      if (this.isEditMode) { //如果处于编辑模式
        Column() {
          Checkbox() //单选框
            .margin({right: $r('app.float.list_padding')})
            .width(CommonConstants.CHECKBOX_WIDTH)
            .selectedColor($r('app.color.main_blue'))
            .onChange((isChecked) => { //点击后，给任务选择状态赋值
              this.selectedTasks[this.index] = isChecked
              if (!this.selectedTasks.includes(false)){  //如果选中的数组里没有false
                this.selectAll = true;  //就把全选参数设为true
              }
              else {
                this.selectAll = false; //否则就把全选参数设为false
              }
            })
              //选中状态，与点击绑定
            .select(this.selectedTasks[this.index])
        }
        .height(CommonConstants.FULL_HEIGHT)
        .justifyContent(FlexAlign.Center) //列元素居中
      }
    }.width(CommonConstants.FULL_WIDTH)
    .height(this.isExpanded ? $r('app.float.expanded_item_height')
      : $r('app.float.list_item_height'))






  }
}