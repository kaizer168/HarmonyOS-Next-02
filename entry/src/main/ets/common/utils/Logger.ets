import { hilog } from '@kit.PerformanceAnalysisKit'

class Logger {
  private prefix = 'Tasksman101' //日志输出文字的前缀，通常是App工程名
  private domain = 0xFF00 //log服务专属域的值，16进制，从0x0~0xFFFF之间
  private format = '%{public}s, %{public}s' //具体日志内容字符串的格式, 2个字符串

  //debug输出
  debug(...args: string[]) {
    hilog.debug(this.domain, this.prefix, this.format, args)
  }

  //error输出
  error(...args: string[]){
    hilog.error(this.domain, this.prefix, this.format, args)
  }

}

export default new Logger()