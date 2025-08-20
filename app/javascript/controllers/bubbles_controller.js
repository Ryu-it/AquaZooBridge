import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]

  connect() {
    // すでに同じセッションで実行済みならスキップ
    // if (sessionStorage.getItem("bubblesPlayed") === "1") return

    // 演出スタート
    this.playEffect()

    // 記録を保存
    // sessionStorage.setItem("bubblesPlayed", "1")
  }

  playEffect() {
    // ここに「最初に大量発生して2秒間だけ…」のコードを移植
    for (let i = 0; i < 80; i++) this.createBubble()

    this.interval = setInterval(() => {
      for (let i = 0; i < 4; i++) this.createBubble()
    }, 40)

    setTimeout(() => {
      clearInterval(this.interval)
    }, 2000)
  }

  createBubble() {
    const el = document.createElement("div")
    el.className = "bubble"
    el.style.left = Math.random() * 100 + "%"
    const size = 4 + Math.random() * 26
    el.style.width = size + "px"
    el.style.height = size + "px"
    el.style.animationDuration = (2 + Math.random() * 3.5) + "s"
    this.containerTarget.appendChild(el)
    el.addEventListener("animationend", () => el.remove())
  }
}
