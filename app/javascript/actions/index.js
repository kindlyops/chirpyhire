import { CALL_API } from `redux-api-middleware`

const getBot = botId => ({
  [CALL_API]: {
    endpoint: `/bots/${botId}`,
    method: 'GET',
    types: ['REQUEST', 'SUCCESS', 'FAILURE']
  }
})

