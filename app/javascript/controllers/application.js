import { Application } from "@hotwired/stimulus"

const application = Application.start();
const context = require.context("./controllers", true, /\.js$/);
context.keys().forEach((key) => {
  const controller = context(key).default
  const controllerName = key.replace(/^.*[\\\/]/, "").replace("_controller.js", "")
  application.register(controllerName, controller)
})