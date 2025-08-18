import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="share"
export default class extends Controller {
  static values = { url: String, text: String }

  connect() { this.element.addEventListener("click", () => this.open()) }

  async open() {
    const url  = this.urlValue
    const text = this.textValue

    if (navigator.share) {
      try {
        await navigator.share({ title: text, text, url })
        return
      } catch (_) { /* キャンセル等は無視 */ }
    }
    // フォールバック：LINE共有URLを新規タブで
    const lineUrl = `https://social-plugins.line.me/lineit/share?url=${encodeURIComponent(url)}&text=${encodeURIComponent(text)}`
    window.open(lineUrl, "_blank", "noopener")
  }
}
