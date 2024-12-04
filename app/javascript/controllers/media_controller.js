import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["widget"];

  seek(event) {
    event.preventDefault();
    const mediaWidgetId = event.currentTarget.dataset.mediaWidgetId;
    const widgetDiv = document.getElementById(mediaWidgetId);
    const iframe = widgetDiv ? widgetDiv.querySelector("iframe") : null;
    
    if (iframe) {
      const time = parseInt(event.currentTarget.dataset.time, 10);
      let videoSrc = iframe.src.split("?")[0];
      videoSrc += `?start=${time}&autoplay=1&enablejsapi=1`;
      iframe.src = videoSrc;
    }
  }
}