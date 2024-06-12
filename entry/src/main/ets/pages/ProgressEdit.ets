import { promptAction } from '@kit.ArkUI'

// @Entry
@Component export
struct ProgressEdit {
  //进度，来自上一级的任务数据。 单位为百分比，进度可以反馈给上级，但是为了预览，临时Prop
  @Prop progress: number = 10 //
  //滑动模式
  @State mode: number = 1
  //点击取消
  onCancel? : () => void
  //点击确定后，返回进度
  onConfirm? : (progress: number) => void

  build() {
    Column() {
      Row({ space: 10 }) {
        Slider({
          value: this.progress, //进度
          step: 1, //步长，每次加1
          style: SliderStyle.InSet //滑块在轨道内
        })
          .width('80%')
          .onChange((value, mode) => {
            this.progress = Math.trunc(value) //进度取整数
            this.mode = mode
          })

        Text(this.progress + '%')//进度百分比
          .fontSize($r('sys.float.ohos_id_text_size_button1'))//系统1号按钮大小
          .fontColor($r('sys.color.ohos_id_text_color_active')) //活跃文字的颜色

      }.justifyContent(FlexAlign.Center) //Row的主轴方向（水平），元素居中排列
      .width('100%')

      Row(){
        TextButton({title: '取消'})
          .onClick(() => {
            if (this.onCancel) {
              this.onCancel()
            }
          })
        Blank()
        TextButton({title: '确定'})
          .onClick(() =>{
            if (this.onConfirm) {
              this.onConfirm(this.progress) //返回进度值
            }
          })
      }.width('70%').padding(10)
    }
  }
}

@Component
struct TextButton {
  //背景色：正常按钮颜色
  @State bgColor: Resource = $r('sys.color.ohos_id_color_button_normal')
  title: ResourceStr = '标题' //标题确定后不变，所以只使用普通变量

  build() {
    Text(this.title)
      .backgroundColor(this.bgColor)//背景色
      .borderRadius(10)//按钮圆角
      .fontSize($r('sys.float.ohos_id_text_size_button1'))//系统1号按钮大小
      .fontColor($r('sys.color.ohos_id_text_color_active'))//活跃文字的颜色
      .width(96)
      .textAlign(TextAlign.Center)
      .onTouch((e) => { //点击按钮后
        if (e.type == TouchType.Down) { //如果是按下，
          //Picker选择器的按下色
          this.bgColor = $r('sys.color.ohos_id_picker_press_color')
        }
        if (e.type == TouchType.Up) { //如果松开，背景色还原
          this.bgColor = $r('sys.color.ohos_id_color_button_normal')
        }
      })
      .padding(5) //内边距5
  }
}