// @Entry
@Component @CustomDialog
export default
struct AddTask {
  @State taskName: string = '' //任务名
  ctrl?: CustomDialogController
  onConfirm? : (value: string) => void

  build() {
      Column({space: 10}) {
        Text('添加任务')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .width('100%')

        TextInput({placeholder: '输入任务名'})
          .onChange((value) => { //输入框变化时，更新任务名
            this.taskName = value
          })

        Row(){
          Button('取消')
            .onClick(() =>{
              this.ctrl?.close()
            })
          Blank()
          Button('确定')
            .onClick(() => {
              if (this.onConfirm) {
                this.onConfirm(this.taskName)
              }
            })
        }
        .padding(20)
        .width('100%')
        .height('10%')
      }
      .padding(20)
      .width('90%')
      .backgroundColor(Color.White)
      .borderRadius(15)
  }
}