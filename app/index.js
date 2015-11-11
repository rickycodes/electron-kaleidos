'use strict'

const config = require('./config.js')
const sa = require('spectrum-analyzer')
const analyzer = new sa(config.track, 32, 0.80)

require('kaleidoscope')(config, analyzer)
require('scene')(config, analyzer)
