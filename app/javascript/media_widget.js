document.addEventListener("DOMContentLoaded", () => {
  // 1つ目のURL入力欄に対する処理
  setupMediaWidget('media_url_1', 'media_player_1');

  // 2つ目のURL入力欄に対する処理
  setupMediaWidget('media_url_2', 'media_player_2');
  
  // ウィジェットをセットアップする関数
  function setupMediaWidget(inputId, playerId) {
    const mediaUrlField = document.getElementById(inputId);
    const mediaPlayer = document.getElementById(playerId);

    if (mediaUrlField && mediaPlayer) {
      mediaUrlField.addEventListener('input', () => {
        const url = mediaUrlField.value;
        const mediaId = extractMediaId(url);
        
        if (mediaId) {
          const embedUrl = `https://www.youtube.com/embed/${mediaId}`;
          const iframeHtml = `<iframe width="560" height="315" src="${embedUrl}" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>`;
          mediaPlayer.innerHTML = iframeHtml;
        } else {
          mediaPlayer.innerHTML = '';
        }
      });
    }
  }

  // 動画IDを抽出する関数
  function extractMediaId(url) {
    const regExp = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|&v=)([^#\&\?]*).*/;
    const match = url.match(regExp);
    return (match && match[2].length === 11) ? match[2] : null;
  }
});