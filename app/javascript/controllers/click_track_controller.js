// app/javascript/controllers/click_track_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String }

  track(event) {
    const url = this.urlValue
    if (!url) return

    const token = document.querySelector('meta[name="csrf-token"]')?.content

    fetch(url, {
      method: "POST",
      headers: {
        "X-Requested-With": "XMLHttpRequest",
        "Accept": "text/vnd.turbo-stream.html, text/html, application/json",
        ...(token ? { "X-CSRF-Token": token } : {})
      },
      credentials: "same-origin",
      body: "" // パラメータ不要なら空でOK
    }).catch(() => {})
  }
}
