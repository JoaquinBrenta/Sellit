import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["modalPop"]

  connect() {
  }

  close() {
    this.clearModal()
  }

  clearModal() {
    this.modalPopTarget.classList.add("d-none")
    this.element.remove()
    const modalFrame = document.querySelector('turbo-frame#modal')
    if (modalFrame) {
      modalFrame.removeAttribute("src")
      modalFrame.innerHTML = ''
    }
  }
}

