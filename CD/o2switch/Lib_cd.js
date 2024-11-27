import { promisify } from 'util'
import { exec as cp_exec } from 'child_process'
import { Octokit, App } from 'octokit'

let config = null
const exec = promisify(cp_exec);

async function cmd(command) {
  try {
    console.log(`Exécution : ${command}`)
    const { stdout, stderr } = await exec(command, { stdio: 'inherit' })
    if (stdout !== '') {
      console.log(stdout)
    }
    if (stderr !== '') {
      console.log(stderr)
    }
    console.log('succès.')
    return stdout
  } catch (error) {
    console.error(err.message)
  }
}

export async function init(modulJson) {
  if (config === null) {
    config = modulJson
  }
}

// export async function modelApp() {
//   return await cmd(``)
// }

export async function createApp() {
  return await cmd(`cloudlinux-selector create --json --interpreter nodejs --app-root "${config.appRoot}" --domain "${config.domain}" --app-uri "${config.appRoot}"`)
}

export async function npmiApp() {
  return await cmd(`cloudlinux-selector install-modules --json --interpreter nodejs --domain "${config.domain}" --app-root "${config.appRoot}"`)
}

export async function npmrunApp(scriptName, script_opt1, script_opt2) {
  return await cmd(`cloudlinux-selector run-script --json --interpreter nodejs --domain "${config.domain}" --app-root "${config.appRoot}" --script-name "${scriptName}" -- --script_opt1 --script_opt2 "${script_opt1}" "${script_opt2}"`)
}

export async function startApp() {
  return await cmd(`cloudlinux-selector start --json --interpreter nodejs --domain "${config.domain}" --app-root "${config.appRoot}"`)
}

export async function stopApp() {
  return await cmd(`cloudlinux-selector stop --json --interpreter nodejs --domain "${config.domain}" --app-root "${config.appRoot}"`)
}
