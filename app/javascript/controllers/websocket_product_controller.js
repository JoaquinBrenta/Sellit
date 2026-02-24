import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  connect() {
    const productId = this.element.dataset.productId
    createConsumer().subscriptions.create(
      { channel: "ProductChannel", room: productId },
      {
        received(data) {
          if (data.action === "update") {
            const modalFrame = document.querySelector("turbo-frame#modal")
            if (modalFrame && modalFrame.src) {
              modalFrame.reload()
            } else if (modalFrame) {
              modalFrame.src = `/products/${productId}`
            }
          }
        }
      }
    )
  }
}

