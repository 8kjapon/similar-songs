// 楽曲登録フォームのマルチステップ入力機能用のコード
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // ステップのターゲットになるエリアを設定
  static targets = ["step"]

  // 初期設定
  connect() {
    // 現在のステップを取得
    const currentStepIndex = parseInt(this.element.dataset.currentStep, 10) || 0
    this.currentStepIndex = currentStepIndex
    
    // 全体ステップ数を取得
    this.totalSteps = this.stepTargets.length

    // 現在のステップを表示
    this.showStep(this.currentStepIndex)
  }

  // ステップを表示する為の処理
  showStep(index) {
    // 全ステップを非表示にしてから、現在のステップだけを表示
    this.stepTargets.forEach((step, i) => {
      step.classList.toggle("hidden", i !== index)
    })
    this.currentStepIndex = index
  }

  // 次ステップに進める為の処理
  nextStep() {
    // 次のステップがある場合は処理を実行
    if (this.currentStepIndex < this.totalSteps - 1) {
      this.showStep(this.currentStepIndex + 1)
    }
  }

  // 前ステップに戻る為の処理
  previousStep() {
    // 前のステップがある場合は処理を実行
    if (this.currentStepIndex > 0) {
      this.showStep(this.currentStepIndex - 1)
    }
  }
}
