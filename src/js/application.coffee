require('semantic-ui-css/semantic.js')
require('pixi.js')

Vue = require('vue')
Turbolinks = require('turbolinks')

Turbolinks.start()

$ ->
  $('.ui.modal').modal('show')
  if document.getElementById('message')
    app = new Vue({
      el: '#message',
      data: {
        message: 'Vue is Work!'
      }
    })
  arena = document.getElementById('arena')
  if arena
    renderer = PIXI.autoDetectRenderer(256, 256, arena)
    document.body.appendChild(renderer.view)
    stage = new PIXI.Container()
    renderer.render(stage)
