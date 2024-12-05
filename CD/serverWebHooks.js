import { createServer } from 'http'
import crypto from 'crypto'
import { text } from 'stream/consumers'
import 'dotenv/config'
import cron from './o2switch/cron_cd.js'

const SECRET = process.env.WEBHOOKS_SECRET
const TOKEN = process.env.WEBHOOKS_TOKEN
const UNIQUE_PATH = process.env.WEBHOOKS_UNIQUE_PATH

const whLog = (msg) => {
  const d = new Date()
  console.log(`${d.toLocaleDateString('fr')} ${d.toLocaleTimeString('fr')} log: ${msg}`)
}

function verifySignature(payload, signature, secret) {
  const computedSignature = `sha256=${crypto
    .createHmac('sha256', secret)
    .update(payload)
    .digest('hex')}`
  return crypto.timingSafeEqual(Buffer.from(signature), Buffer.from(computedSignature))
}

const server = createServer(async (req, res) => {
  res.setHeader('X-Robots-Tag', 'noindex, nofollow');
  if (req.method === 'POST' && req.url === UNIQUE_PATH) {
    try {
      // if (req.headers['x-webhook-token'] !== TOKEN) {
      //   res.statusCode = 403
      //   return res.end('Forbidden')
      // }

      if (req.headers['content-type'] !== 'application/json') {
        whLog('Invalid Content-Type, expected application/json')
        res.statusCode = 400
        return res.end('Invalid Content-Type, expected application/json')
      }

      const body = await text(req)
      const signature = req.headers['x-hub-signature-256']
      if (!signature || !verifySignature(body, signature, SECRET)) {
        whLog('Invalid signature')
        res.statusCode = 401
        return res.end('Invalid signature')
      }

      const data = JSON.parse(body)
      whLog('Accepted')
      res.statusCode = 202
      res.end('Accepted')

      const githubEvent = req.headers['x-github-event']
      if (githubEvent === 'release') {
        whLog('Données de la release:', data)
        cron(JSON.stringify(data, null, '\t'))
      } else {
        whLog(`Unhandled event: ${githubEvent}`)
      }
    } catch (error) {
      console.error('Erreur lors du traitement de la requête:', error)
      res.statusCode = 500
      res.end('Internal Server Error')
    }
  } else {
    res.statusCode = 404
    res.end('Not Found')
  }
})

server.listen('passenger' || 3000, () => {
  const address = server.address()
  const url = `http://${address.address === '::' ? 'localhost' : address.address}:${address.port}`
  whLog(`Server is running at ${url}${UNIQUE_PATH}`)
})
