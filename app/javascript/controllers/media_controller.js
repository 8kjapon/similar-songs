// SongPairsHelperのparse_time_linksメソッドで変換された再生時間移動リンクのクリックを検知し、対応するプレイヤーウィジェットを再生する処理
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  // ウィジェットをターゲットに
  static targets = ["widget"];

  // クリック時に行う処理
  seek(event) {
    const mediaWidgetId = event.currentTarget.dataset.mediaWidgetId; // ウィジェットのidを取得
    const widgetDiv = document.getElementById(mediaWidgetId); // ウィジェット(iframe)を含む親要素divの取得
    const iframe = widgetDiv ? widgetDiv.querySelector("iframe") : null; // ウィジェットの本体(iframe)部分の取得
    
    // iframeが存在していれば指定の再生時間に移動するようにウィジェット設定を変更
    if (iframe) {
      const time = parseInt(event.currentTarget.dataset.time, 10); // 指定された再生時間の秒数を10進数で取得

      // ウィジェットの設定(Src部分のURLを置き換えることで変更)
      let videoSrc = iframe.src.split("?")[0];
      videoSrc += `?start=${time}&autoplay=1&enablejsapi=1`;
      iframe.src = videoSrc;
    }
  }
}