import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "identificacao", "privModal" ]

  // Toggles the name/email section based on radio selection
  toggle(event) {
    const isIdentified = event.target.value === "identificado"
    this.identificacaoTarget.hidden = !isIdentified
  }

  // Opens the privacy modal using the native Dialog API
  openPriv(event) {
    event.preventDefault() // Prevents any accidental form jumping
    this.privModalTarget.showModal()
  }

  // Closes the privacy modal
  closePriv() {
    this.privModalTarget.close()
  }
}