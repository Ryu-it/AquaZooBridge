import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["name", "url"]

  connect() {
    this.timeout = null
  }

  fetch() {
    clearTimeout(this.timeout)
    const name = this.nameTarget.value.trim()
    if (!name) return

    // 少し待ってから実行（連打対策）
    this.timeout = setTimeout(() => {
      fetch("/lookups", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
        },
        body: JSON.stringify({ name: name })
      })
        .then(res => res.json())
        .then(data => {
          if (data.url) {
            this.urlTarget.value = data.url
          }
        })
        .catch(e => {
          console.error("検索失敗", e)
        })
    }, 500)
  }
}
