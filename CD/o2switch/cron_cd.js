import { init, startApp, stopApp } from './Lib_cd.js'
import config from './cd.config.json' with { type: 'json' }

await init(config)
/**
 * get info release in repo git
 * get current
 * check version for update, current < last
 *    not update exit
 * get archive name
 * get archive url
 * archive download and save
 * archive extract
 * stop app
 * start app maintenance
 * save olld app
 * install update
 * test app postinstall
 * stop app maintenance
 * start app
 * test app poststart
 */

// stopApp()
// startApp()

function cron(data) {
  console.log(JSON.stringify(data, null, '\t'))
}

export default cron