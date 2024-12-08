// 楽曲登録フォームの曲名部分のオートコンプリート機能処理部分
// stilumus-autocompleteを拡張し、自動入力対象を曲名だけでなく関連するアーティストやリリース年などのフォームに広げる
import { Autocomplete } from "stimulus-autocomplete";

export default class extends Autocomplete {
  // オートコンプリート機能の対象になるフォームを設定
  // input: 曲名
  // artist: アーティスト名
  // releaseDate: リリース年
  // mediaUrl: メディアURL
  static targets = ["input", "artist", "releaseDate", "mediaUrl"];

  commit(selected) {
    const label = selected.getAttribute("data-autocomplete-label"); // 曲名
    const artist = selected.getAttribute("data-artist"); // アーティスト名
    const releaseDate = selected.getAttribute("data-release-date"); // リリース年
    const mediaUrl = selected.getAttribute("data-media-url"); // メディアURL

    // 入力フィールドに曲名を反映
    this.inputTarget.value = label;

    // 対応するフィールドにそれぞれの値を反映
    if (this.hasArtistTarget) {
      this.artistTarget.value = artist || "";
    }
    if (this.hasReleaseDateTarget) {
      this.releaseDateTarget.value = releaseDate || "";
    }
    if (this.hasMediaUrlTarget) {
      this.mediaUrlTarget.value = mediaUrl || "";
    }

    // リストを閉じる
    this.close();
  }
}