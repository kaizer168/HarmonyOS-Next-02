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
        
      @Link selectAll: boolean  //把这个全选参数传进来再回传  
  
      if (this.isEditMode) {   
        Column() {  
          Checkbox()   
            .margin({right: $r('app.float.list_padding')})  
            .width(CommonConstants.CHECKBOX_WIDTH)  
            .selectedColor($r('app.color.main_blue'))  
            .onChange((isChecked) => {   
              this.selectedTasks[this.index] = isChecked  
              if (!this.selectedTasks.includes(false)){  //如果选中的数组里没有false  
                this.selectAll = true;  //就把全选参数设为true      
              }  
              else {  
                this.selectAll = false; //否则就把全选参数设为false              
              }  
            })  
                
            .select(this.selectedTasks[this.index])  
        }  
        .height(CommonConstants.FULL_HEIGHT)  
        .justifyContent(FlexAlign.Center)   
      }  
      
TaskList.ets:  
        
      } else {   
        Text($r('app.string.edit_button'))  
          .operateTextStyle($r('app.color.main_blue'))  
          .onClick(() => {  
            this.isEditMode = true   
            this.selectedTasks = this.tasks.map(() => false)  //启用编辑模式时，把选中数组设为全false  
          })  
      }  

      List({space: CommonConstants.LIST_SPACE}){
        ForEach(this.tasks,(item: Task,index) => {
          ListItem() {
            TaskItem({
              task: item, 
              index: index,
              isEditMode: this.isEditMode,
              selectedTasks: this.selectedTasks, 
              clickIndex: this.clickIndex, 
              selectAll: this.selectAll //加这个全选参数(双向)
            })
          }
        })
      }
