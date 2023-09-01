/* global Turbo */
// Entry point for the build script in your package.json
import "@hotwired/turbo-rails";
import "./controllers";
import * as bootstrap from "bootstrap";

document.addEventListener("DOMContentLoaded", function () {
  if (window.Turbo) {
    Turbo.session.drive = false;
  }
});
