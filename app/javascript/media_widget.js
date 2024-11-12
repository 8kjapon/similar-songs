// 楽曲登録フォームでメディアのウィジェットを自動表示する機能用のコード
document.addEventListener("turbo:load", () => {
  // 1つ目のURL入力欄に対する処理
  setupMediaWidget('media_url_1', 'media_player_1');

  // 2つ目のURL入力欄に対する処理
  setupMediaWidget('media_url_2', 'media_player_2');
  
  // ウィジェットをセットアップする関数
  function setupMediaWidget(inputId, playerId) {
    // 入力されたURLを取得
    const mediaUrlField = document.getElementById(inputId);

    // ウィジェット(プレイヤー)表示用のエリアを取得
    const mediaPlayer = document.getElementById(playerId);

    // 必要情報がある場合はウィジェットを表示
    if (mediaUrlField && mediaPlayer) {
      // ウィジェットを表示
      updateMediaPlayer(mediaUrlField.value, mediaPlayer)

      // URLの手動入力を監視
      mediaUrlField.addEventListener('input', () => {
        const normalizedUrl = normalizeYouTubeUrl(mediaUrlField.value);
        mediaUrlField.value = normalizedUrl;
        updateMediaPlayer(mediaUrlField.value, mediaPlayer)
      });

      // URLの自動入力を監視(オートコンプリート等での自動入力対応)
      mediaUrlField.addEventListener('change', () => {
        const normalizedUrl = normalizeYouTubeUrl(mediaUrlField.value);
        mediaUrlField.value = normalizedUrl;
        updateMediaPlayer(mediaUrlField.value, mediaPlayer)
      });

      // 上記の入力監視に対応しきれない場合に備えて定期監視
      let previousValue = mediaUrlField.value;
      setInterval(() => {
        if (mediaUrlField.value !== previousValue) {
          previousValue = mediaUrlField.value;
          const normalizedUrl = normalizeYouTubeUrl(mediaUrlField.value);
          mediaUrlField.value = normalizedUrl;
          updateMediaPlayer(mediaUrlField.value, mediaPlayer)
        }
      }, 1000);  // 1秒ごとにチェック
    }
  }

  // ウィジェット(プレイヤー)表示用の処理
  function updateMediaPlayer(url, playerElement) {
    // URLからYouTubeの動画IDを取得
    const mediaId = extractMediaId(url);

    // IDが有効なら表示、取得できなければ何も表示しない
    if (mediaId) {
      const embedUrl = `https://www.youtube.com/embed/${mediaId}`;
      const iframeHtml = `<div class="media-widget"><iframe src="${embedUrl}" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>`;
      playerElement.innerHTML = iframeHtml;
    } else {
      playerElement.innerHTML = '';
    }
  }

  // YouTubeのURLをシンプルな形式に変換する処理
  function normalizeYouTubeUrl(url) {
    const mediaId = extractMediaId(url);
    if (mediaId) {
      return `https://www.youtube.com/watch?v=${mediaId}`;
    }
    return url;
  }

  // 動画IDを抽出する関数
  function extractMediaId(url) {
    const regExp = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|&v=)([^#\&\?]*).*/;
    const match = url.match(regExp);
    return (match && match[2].length === 11) ? match[2] : null;
  }
});