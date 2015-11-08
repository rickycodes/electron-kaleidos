'use strict'

const config = require('./config.js')
const sa = require('spectrum-analyzer')
const audio = document.createElement('audio')
const analyzer = new sa(32 * 0.5, 0.80)

audio.crossOrigin = 'anonymous'
audio.src = config.track
analyzer.setSource(audio)

audio.currentTime = 0
audio.play()

audio.addEventListener('ended', function (e) {
  // console.log('loop!')
  this.currentTime = 0
  this.play()
})

require('kaleidoscope')(config, analyzer)
require('scene')(config, analyzer)
