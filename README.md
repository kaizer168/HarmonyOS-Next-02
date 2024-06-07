# 排除「任务进度管理」bug
Debug 1: 删除选中的1个任务, 会把没选中的其他任务也删除
原代码: Tasks.ets
  del(selected: boolean[]) {
    //对任务组进行筛选， 只取index序号
    this._allData = this._allData.filter((_ ,index) => {
      //如果某一项的序号，在选中任务组中存在，则排除掉
      return !selected.includes(selected[index])
    })
  }

修改代码：Tasks.ets
    //删除选中的1个或多个任务，selected: 任务选中状态数组，长度与任务数一致
  del(selected: boolean[]) {
    //对任务组进行筛选， 只取index序号
    this._allData = this._allData.filter((_ ,index) => {
      //如果某一项的序号，在选中任务组中存在，则排除掉
      //return !selected.includes(selected[index])
      return !selected[index]
    })
  }

  
