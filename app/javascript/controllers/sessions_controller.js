import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["password", "eyeOpen", "eyeClose", "requirement"]

  toggle(event) {
    event.preventDefault()
    const isPassword = this.passwordTarget.type === "password"
    this.passwordTarget.type = isPassword ? "text" : "password"
    
    this.eyeOpenTarget.style.display = isPassword ? "none" : "block"
    this.eyeCloseTarget.style.display = isPassword ? "block" : "none"
  }


  check(event) {
    const value = event.target.value
    
    const rules = {
      length: value.length >= 8,
      number: /[0-9]/.test(value),
      special: /[!@#$%^&*]/.test(value),
      nospace: !/\s/.test(value) && value.length > 0
    }

    this.requirementTargets.forEach(el => {
      const rule = el.dataset.rule
      const isValid = rules[rule]
      
      // Toggle a class or style for visual feedback
      el.style.color = isValid ? "#28a745" : "#6c757d"
      el.querySelector(".status-icon").innerHTML = isValid ? "●" : "○"
    })
  }
}