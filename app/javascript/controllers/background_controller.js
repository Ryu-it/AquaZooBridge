import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["bg"]
  static classes = ["sky", "lime"]

  connect() {
    this.interval = setInterval(() => this.toggleBackground(), 3000)
  }

  disconnect() {
    clearInterval(this.interval)
  }

  toggleBackground() {
    this.bgTarget.classList.toggle(this.skyClass)
    this.bgTarget.classList.toggle(this.limeClass)
  }
}
