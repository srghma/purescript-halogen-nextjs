import express from 'express'
import pg from 'pg'

import initFacebookOauth from 'modules/initFacebookOauth'
import initPostgraphile from 'modules/initPostgraphile'

import allowCrossDomain from 'lib/allowCrossDomain'

const app = express()

const isProd = process.env.NODE_ENV === 'production'

const rootPgPool = new pg.Pool({
  connectionString: process.env.DATABASE_URL,
})

if (process.env.CORS_ALLOW_ORIGIN) {
  if (isProd) {
    // don't use it in prod because it's costly option, use nginx in prod
    console.warn(
      `warning: CORS_ALLOW_ORIGIN=${process.env.CORS_ALLOW_ORIGIN} enabled in production!!! it's costly option, better use nginx`,
    )
  }

  app.use(
    allowCrossDomain({
      corsAllowOrigin: process.env.CORS_ALLOW_ORIGIN,
    }),
  )
}

if (process.env.FACEBOOK_APP_ID || process.env.FACEBOOK_APP_SECRET) {
  initFacebookOauth(app, {
    rootPgPool,
    clientID:     process.env.FACEBOOK_APP_ID,
    clientSecret: process.env.FACEBOOK_APP_SECRET,
    jwtSecret:    process.env.JWT_SECRET,
  })
} else {
  console.warn(
    "warning: Facebook oauth disabled because credentials wasn't found",
  )
}

app.use(
  initPostgraphile({
    isProd,
    databaseUrl:          process.env.DATABASE_URL,
    exposedSchema:        process.env.EXPOSED_SCHEMA,
    exportGqlSchemaPath:  process.env.EXPORT_GQL_SCHEMA,
    exportJsonSchemaPath: process.env.EXPORT_JSON_SCHEMA,
    jwtSecret:            process.env.JWT_SECRET,
  })
)

const server = app.listen(process.env.PORT, process.env.HOST, err => {
  if (err) throw err

  console.log(
    'info: Express server started on %s:%s, mode - %s',
    server.address().address,
    server.address().port,
    app.settings.env,
  )
})
