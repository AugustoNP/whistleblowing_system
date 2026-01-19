import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  // Connects a global listener when the controller is on the page
  connect() {
    this.closeHandler = this.closeOnClickOutside.bind(this)
    window.addEventListener("click", this.closeHandler)
  }

  // Cleans up the listener when navigating away
  disconnect() {
    window.removeEventListener("click", this.closeHandler)
  }

  toggle(event) {
    event.stopPropagation() // Prevents the global listener from firing immediately
    this.menuTarget.hidden = !this.menuTarget.hidden
  }

  closeOnClickOutside(event) {
    // If the click is NOT inside the dropdown, hide it
    if (!this.element.contains(event.target)) {
      this.menuTarget.hidden = true
    }
  }
}