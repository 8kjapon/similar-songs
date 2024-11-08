import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  static targets = ["step"]

  connect() {
    const currentStepIndex = parseInt(this.element.dataset.currentStep, 10) || 0
    this.currentStepIndex = currentStepIndex
    this.totalSteps = this.stepTargets.length
    this.showStep(this.currentStepIndex)
  }

  showStep(index) {
    // 全ステップを非表示にしてから、現在のステップだけを表示
    this.stepTargets.forEach((step, i) => {
      step.classList.toggle("hidden", i !== index)
    })
    this.currentStepIndex = index
  }

  nextStep() {
    if (this.currentStepIndex < this.totalSteps - 1) {
      this.showStep(this.currentStepIndex + 1)
    }
  }

  previousStep() {
    if (this.currentStepIndex > 0) {
      this.showStep(this.currentStepIndex - 1)
    }
  }
}
