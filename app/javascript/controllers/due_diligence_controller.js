import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "uboInfo", "interPubTxt", "pepBlock", "parentescoBlock", "relacaoBlock",
    "ocorResumo", "invTxt", "impedTxt", "falTxt", "cadRestrTxt", "codUrl", 
    "pacUrl", "progUrl", "brindesTxt", "ddtTxt", "canalContato", "monitTxt", "tercBlock"
  ]

  connect() {
    console.log("Due Diligence UI Initialized");
    
    // Run visibility checks for all radio-toggles on page load
    // We pass the element directly to the toggle method
    this.element.querySelectorAll('input[type="radio"]:checked').forEach((radio) => {
      this.toggle(radio);
    });
    
    // Run check for checkboxes
    this.toggleCheck();
  }

  // --- Dynamic Table Logic ---
  addRow(event) {
    event.preventDefault();
    const tableId = event.currentTarget.dataset.tableId;
    const table = document.getElementById(tableId);
    const template = document.getElementById(`${tableId}-template`);

    if (template && table) {
      const tbody = table.querySelector("tbody");
      const clone = template.content.cloneNode(true);
      tbody.appendChild(clone);
    } else {
      console.error("Template or Table not found for ID:", tableId);
    }
  }

  removeRow(event) {
    event.preventDefault();
    const row = event.target.closest("tr");
    if (row) row.remove();
  }

  // --- Visibility Toggles ---
  // Modified to handle both browser events and manual calls from connect()
  toggle(event) {
    const element = event.target || event;
    const targetName = element.dataset.targetName;
    
    if (!targetName) return;

    const target = this[`${targetName}Target`];
    if (target) {
      // Show if value is "Sim", hide otherwise
      target.hidden = (element.value !== "Sim");
      
      // Optional: Logic to clear inner inputs if hidden
      if (target.hidden) {
        const inputs = target.querySelectorAll('input, textarea');
        inputs.forEach(i => { if(i.type !== 'radio') i.value = "" });
      }
    }
  }

  toggleCheck() {
    const checkboxes = this.element.querySelectorAll('.ocor-check');
    const anyChecked = Array.from(checkboxes).some(c => c.checked);
    if (this.hasOcorResumoTarget) {
      this.ocorResumoTarget.hidden = !anyChecked;
    }
  }

  // --- Validation Logic ---
  validateCNPJ(event) {
    const input = event.target;
    const cnpj = input.value.replace(/[^\d]+/g, '');
    
    if (cnpj.length === 0) {
        this.clearError(input);
        return;
    }

    if (cnpj.length !== 14 || /^(\d)\1+$/.test(cnpj)) {
      this.setError(input, "CNPJ Inválido");
      return;
    }

    // Validation algorithm
    let size = cnpj.length - 2;
    let numbers = cnpj.substring(0, size);
    const digits = cnpj.substring(size);
    let sum = 0;
    let pos = size - 7;
    
    for (let i = size; i >= 1; i--) {
      sum += numbers.charAt(size - i) * pos--;
      if (pos < 2) pos = 9;
    }
    
    let result = sum % 11 < 2 ? 0 : 11 - (sum % 11);
    if (result != digits.charAt(0)) {
      this.setError(input, "CNPJ Inválido");
      return;
    }

    size = size + 1;
    numbers = cnpj.substring(0, size);
    sum = 0;
    pos = size - 7;
    for (let i = size; i >= 1; i--) {
      sum += numbers.charAt(size - i) * pos--;
      if (pos < 2) pos = 9;
    }
    result = sum % 11 < 2 ? 0 : 11 - (sum % 11);
    if (result != digits.charAt(1)) {
      this.setError(input, "CNPJ Inválido");
      return;
    }

    this.clearError(input);
  }

  validatePastDate(event) {
    const input = event.target;
    if (!input.value) return;
    const selectedDate = new Date(input.value);
    const today = new Date();

    if (selectedDate > today) {
      this.setError(input, "A data não pode ser no futuro");
    } else {
      this.clearError(input);
    }
  }

  // --- Helper Methods ---
  setError(input, message) {
    input.classList.add("form-input--error");
    let errorDisplay = input.nextElementSibling;
    if (!errorDisplay || !errorDisplay.classList.contains("error-msg")) {
      errorDisplay = document.createElement("span");
      errorDisplay.classList.add("error-msg");
      input.parentNode.insertBefore(errorDisplay, input.nextSibling);
    }
    errorDisplay.innerText = message;
    input.setCustomValidity(message);
  }

  clearError(input) {
    input.classList.remove("form-input--error");
    const errorDisplay = input.nextElementSibling;
    if (errorDisplay && errorDisplay.classList.contains("error-msg")) {
      errorDisplay.remove();
    }
    input.setCustomValidity("");
  }
}