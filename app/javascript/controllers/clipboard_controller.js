import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "source", "buttonText" ]

  copy() {

    const text = this.sourceTarget.innerText

    navigator.clipboard.writeText(text).then(() => {

      const originalText = this.buttonTextTarget.innerText
      this.buttonTextTarget.innerText = "Copiado!"

      setTimeout(() => {
        this.buttonTextTarget.innerText = originalText
      }, 2000)
    }).catch(err => {
      console.error("Error copying text: ", err)
      alert("Não foi possível copiar. Por favor, selecione e copie manualmente.")
    })
  }
}