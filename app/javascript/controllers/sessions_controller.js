import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["password", "eyeOpen", "eyeClose"]

  toggle(event) {
    event.preventDefault()
    
    const isPassword = this.passwordTarget.type === "password"
    
    // Switch the input type
    this.passwordTarget.type = isPassword ? "text" : "password"
    
    // Swap the icons
    if (isPassword) {
      this.eyeOpenTarget.style.display = "none"
      this.eyeCloseTarget.style.display = "block"
    } else {
      this.eyeOpenTarget.style.display = "block"
      this.eyeCloseTarget.style.display = "none"
    }
  }
}