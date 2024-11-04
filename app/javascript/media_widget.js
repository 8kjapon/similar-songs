document.addEventListener("turbo:load", () => {
  // 1つ目のURL入力欄に対する処理
  setupMediaWidget('media_url_1', 'media_player_1');

  // 2つ目のURL入力欄に対する処理
  setupMediaWidget('media_url_2', 'media_player_2');
  
  // ウィジェットをセットアップする関数
  function setupMediaWidget(inputId, playerId) {
    const mediaUrlField = document.getElementById(inputId);
    const mediaPlayer = document.getElementById(playerId);

    if (mediaUrlField && mediaPlayer) {
      updateMediaPlayer(mediaUrlField.value, mediaPlayer)

      mediaUrlField.addEventListener('input', () => {
        updateMediaPlayer(mediaUrlField.value, mediaPlayer)
      });

      mediaUrlField.addEventListener('change', () => {
        updateMediaPlayer(mediaUrlField.value, mediaPlayer)
      });

      // 値が自動で入力されてもチェックできるように定期的に監視
      let previousValue = mediaUrlField.value;
      setInterval(() => {
        if (mediaUrlField.value !== previousValue) {
          previousValue = mediaUrlField.value;
          updateMediaPlayer(mediaUrlField.value, mediaPlayer)
        }
      }, 1000);  // 1秒ごとにチェック
    }
  }

  function updateMediaPlayer(url, playerElement) {
    const mediaId = extractMediaId(url);

    if (mediaId) {
      const embedUrl = `https://www.youtube.com/embed/${mediaId}`;
      const iframeHtml = `<div class="media-widget"><iframe src="${embedUrl}" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>`;
      playerElement.innerHTML = iframeHtml;
    } else {
      playerElement.innerHTML = '';
    }
  }

  // 動画IDを抽出する関数
  function extractMediaId(url) {
    const regExp = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|&v=)([^#\&\?]*).*/;
    const match = url.match(regExp);
    return (match && match[2].length === 11) ? match[2] : null;
  }
});