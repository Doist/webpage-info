{spawn, exec} = require 'child_process'

task 'build', 'build media-parser package', ->
  compile = spawn 'sh', ['compile.sh']
  compile.stdout.on 'data', (data) -> console.log data.toString().trim()
