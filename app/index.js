'use strict'

const config = require('./config.js')
const SpectrumAnalyzer = require('spectrum-analyzer')
const analyzer = new SpectrumAnalyzer(config.track, 32, 0.80)

require('kaleidoscope')(config, analyzer)
require('scene')(config, analyzer)
