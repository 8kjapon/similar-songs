import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["songInput", "artistInput", "releaseDate", "mediaUrl", "songList1", "songList2", "artistList1", "artistList2"]

  search() {
    const query = this.songInputTarget.value
    if (query.length < 2) {
      this.clearSuggestions(this.currentSongListTarget())
      return
    }

    fetch(`/songs/autocomplete?query=${query}`)
      .then(response => response.json())
      .then(data => {
        console.log("Artist autocomplete results:", data);
        this.showSuggestions(this.currentSongListTarget(), data, (suggestion) => {
          this.setSongData(suggestion)
        })
      })
  }

  searchArtist() {
    console.log("Input target for artist:", this.inputTarget);
    const query = this.artistInputTarget.value
    console.log("Search query for artist:", query);
    if (query.length < 2) {
      this.clearSuggestions(this.currentArtistListTarget())
      return
    }

    fetch(`/artists/autocomplete?query=${query}`)
      .then(response => response.json())
      .then(data => {
        console.log("Artist autocomplete results:", data);
        this.showSuggestions(this.currentArtistListTarget(), data, (suggestion) => {
          this.artistInputTarget.value = suggestion
        })
      })
  }

  // 現在の入力フィールドに対応する曲候補リストを取得
  currentSongListTarget() {
    if (this.hasSongList1Target && this.songInputTarget.dataset.target === "autocomplete.songInput") {
      // console.log("Song list target 1 found:", this.songList1Target);
      return this.songList1Target
    } else if (this.hasSongList2Target && this.songInputTarget.dataset.target === "autocomplete.songInput") {
      // console.log("Song list target 2 found:", this.songList2Target);
      return this.songList2Target
    } else {
      // console.log("No song list target found");
      return null;
    }
  }

  // 現在の入力フィールドに対応するアーティスト候補リストを取得
  currentArtistListTarget() {
    if (this.hasArtistList1Target && this.artistInputTarget.dataset.target === "autocomplete.artistInput") {
      console.log("Artist list target 1 found:", this.artistList1Target);
      return this.artistList1Target
    } else if (this.hasArtistList2Target && this.artistInputTarget.dataset.target === "autocomplete.artistInput") {
      console.log("Artist list target 2 found:", this.artistList2Target);
      return this.artistList2Target
    }
  }

  setSongData(suggestion) {
    this.songInputTarget.value = suggestion.title;
    this.artistInputTarget.value = suggestion.artists || '';
    this.releaseDateTarget.value = suggestion.release_date || '';
    this.mediaUrlTarget.value = suggestion.media_url || '';
  }

  // オートコンプリート候補を表示する共通関数
  showSuggestions(listElement, suggestions, callback) {
    this.clearSuggestions(listElement) // 既存の候補をクリア

    suggestions.forEach(suggestion => {
      const listItem = document.createElement("li")
      listItem.textContent = typeof suggestion === 'string' ? suggestion : suggestion.title;  // 曲の場合はタイトルを表示
      listItem.classList.add("autocomplete-item")
      listItem.addEventListener("click", () => {
        callback(suggestion)
        this.clearSuggestions(listElement)
      })
      listElement.appendChild(listItem)
    })
  }

  // 候補がクリックされたときに入力フィールドに反映する
  setInputValue(target, value) {
    target.value = value
  }

  // 候補リストをクリアする
  clearSuggestions(listElement) {
    if(!listElement) return;

    while (listElement.firstChild) {
      listElement.removeChild(listElement.firstChild)
    }
  }
}