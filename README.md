# 排除「任务进度管理」bug  
Debug 1: 删除选中的1个任务, 会把没选中的其他任务也删除  
修改代码： 
Tasks.ets  
        
      del(selected: boolean[]) {  
        //对任务组进行筛选， 只取index序号  
        this._allData = this._allData.filter((_ ,index) => {  
          //如果某一项的序号，在选中任务组中存在，则排除掉  
          //return !selected.includes(selected[index])  
          return !selected[index]  //加这一行代替上一行  
        })  
      }  

Debug 2: 编辑时如果选中全部个别任务, 全选不会自动更新为选中  
修改代码： 
TaskItem.ets  
        
      @Link selectAll: boolean  //把这个参数传进来再回传  
  
      if (this.isEditMode) { //如果处于编辑模式  
        Column() {  
          Checkbox() //单选框  
            .margin({right: $r('app.float.list_padding')})  
            .width(CommonConstants.CHECKBOX_WIDTH)  
            .selectedColor($r('app.color.main_blue'))  
            .onChange((isChecked) => { //点击后，给任务选择状态赋值  
              this.selectedTasks[this.index] = isChecked  
              if (!this.selectedTasks.includes(false)){  //如果选中的数组里没有false  
                this.selectAll = true;  //就把全选设为true      
              }  
              else {  
                this.selectAll = false; //否则就把全选设为false              
              }  
            })  
              //选中状态，与点击绑定  
            .select(this.selectedTasks[this.index])  
        }  
        .height(CommonConstants.FULL_HEIGHT)  
        .justifyContent(FlexAlign.Center) //列元素居中  
      }  
      
TaskList.ets:  
        
      } else { //不在编辑模式时,显示编辑文字按钮  
        Text($r('app.string.edit_button'))  
          .operateTextStyle($r('app.color.main_blue'))  
          .onClick(() => {  
            this.isEditMode = true //启用编辑模式  
            this.selectedTasks = this.tasks.map(() => false)  //把数组设为全false  
          })  
      }  
