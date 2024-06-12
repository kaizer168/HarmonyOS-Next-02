
export default
class Task {
  constructor(name: string, update: string, progress: number) {
    this.name = name
    this.update = update
    this.progress = progress
  }
  name: string
  update: string
  progress: number

}