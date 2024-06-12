import { CommonConstants } from '../common/constant/CommonConstant'

@Extend(Text) function subTextStyle(){
  .fontSize($r('sys.float.ohos_id_text_size_sub_title3'))
  .fontColor($r('sys.color.ohos_id_color_text_secondary'))
}

// @Entry
@Component export
struct TaskOverview {
  //接收来自上层的最近更新时间,Prop可以有默认值
  @Prop latestUpdate : string = '2024/3/2 19:00:21'

  @Prop total: number = 3 //总数
  @Prop finish: number = 1 //已完成


  build() {
      Column() {
        this.Header()
        this.TotalProgress()
      }
      .width(CommonConstants.MAIN_BOARD_WIDTH)
      .backgroundColor(Color.White)
      .borderRadius(CommonConstants.TARGET_BORDER_RADIUS)
  }

  @Builder TotalProgress(){
    Row(){
      Column(){
        Text('总进度')
          .fontSize($r('sys.float.ohos_id_text_size_sub_title1'))
          .fontWeight(FontWeight.Bold)
        Row(){
          Text('最近更新：').subTextStyle()
          Text(this.latestUpdate).subTextStyle()
        }
      }.alignItems(HorizontalAlign.Start)

      Blank()

      Stack(){
        Row(){
          Text(this.finish.toString())
            .fontSize($r('sys.float.ohos_id_text_size_sub_title3'))
          Text("/" + this.total.toString())
            .fontSize($r('sys.float.ohos_id_text_size_sub_title3'))
        }

        Progress({
          value: this.finish,
          total: this.total,
          type: ProgressType.Ring
        }).width(50)

      }.padding(20)

    }.width('100%').padding(20)
  }





  @Builder Header(){
    Row() {
      Image($r("app.media.startIcon"))
        .width(96).height(96)
        .objectFit(ImageFit.Fill)
      Column() {
        Text('2024开发任务')
          .fontSize($r('sys.float.ohos_id_text_size_dialog_tittle'))
          .fontWeight(FontWeight.Bolder)
        Text('高质量完成交付')
          .fontColor($r('sys.color.ohos_id_color_text_secondary'))
          .fontSize($r('sys.float.ohos_id_text_size_sub_title1'))
      }
      .margin({ left: 20 })
      .alignItems(HorizontalAlign.Start)
    }
    .padding(20)
    .width('100%')
  }

}