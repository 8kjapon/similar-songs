import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "songList1", "songList2", "artistList1", "artistList2"]

  search() {
    const query = this.inputTarget.value
    if (query.length < 2) {
      this.clearSuggestions(this.currentSongListTarget())
      return
    }

    fetch(`/songs/autocomplete?query=${query}`)
      .then(response => response.json())
      .then(data => {
        this.showSuggestons(this.currentSongListTarget(), data, this.setInputValue)
      })
  }

  searchArtist() {
    const query = this.inputTarget.value
    if (query.length < 2) {
      this.clearSuggestions(this.currentArtistListTarget())
      return
    }

    fetch(`/artists/autocomplete?query=${query}`)
      .then(response => response.json())
      .then(data => {
        this.showSuggestons(this.currentArtistListTarget(), data, this.setInputValue)
      })
  }

  // 現在の入力フィールドに対応する曲候補リストを取得
  currentSongListTarget() {
    if (this.hasSongList1Target && this.inputTarget.dataset.autocompleteTarget === "songList1") {
      return this.songList1Target
    } else if (this.hasSongList2Target && this.inputTarget.dataset.autocompleteTarget === "songList2") {
      return this.songList2Target
    }
  }

  // 現在の入力フィールドに対応するアーティスト候補リストを取得
  currentArtistListTarget() {
    if (this.hasArtistList1Target && this.inputTarget.dataset.autocompleteTarget === "artistList1") {
      return this.artistList1Target
    } else if (this.hasArtistList2Target && this.inputTarget.dataset.autocompleteTarget === "artistList2") {
      return this.artistList2Target
    }
  }

  // オートコンプリート候補を表示する共通関数
  showSuggestions(listElement, suggestions, callback) {
    this.clearSuggestions(listElement) // 既存の候補をクリア

    suggestions.forEach(suggestion => {
      const listItem = document.createElement("li")
      listItem.textContent = suggestion
      listItem.classList.add("autocomplete-item")
      listItem.addEventListener("click", () => {
        callback.call(this, listItem.textContent)
        this.clearSuggestions(listElement)
      })
      listElement.appendChild(listItem)
    })
  }

  // 候補がクリックされたときに入力フィールドに反映する
  setInputValue(value) {
    this.inputTarget.value = value
  }

  // 候補リストをクリアする
  clearSuggestions(listElement) {
    while (listElement.firstChild) {
      listElement.removeChild(listElement.firstChild)
    }
  }
}