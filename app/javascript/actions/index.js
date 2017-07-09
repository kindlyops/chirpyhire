import { CALL_API, getJSON } from 'redux-api-middleware'
import { schema, normalize } from 'normalizr';

const botSchema = new schema.Entity('bots')

const greetingSchema = new schema.Entity('greetings', {
  bot: botSchema
})

const goalSchema = new schema.Entity('goals', {
  bot: botSchema
})

const questionSchema = new schema.Entity('questions', {
  bot: botSchema
})

const followUpSchema = new schema.Entity('follow_ups', {
  question: questionSchema
})

const campaignSchema = new schema.Entity('campaigns')
const inboxSchema    = new schema.Entity('inboxes')

export const getBots = () => ({
  [CALL_API]: {
    endpoint: `/bots`,
    method: 'GET',
    credentials: 'same-origin',
    types: ['REQUEST', {
        type: 'SUCCESS',
        payload: (action, state, res) => {
          return getJSON(res).then((json) => normalize(json, { bots: [botSchema] }));
        }
      }, 'FAILURE']
  }
})

export const getCampaigns = () => ({
  [CALL_API]: {
    endpoint: `/campaigns`,
    method: 'GET',
    credentials: 'same-origin',
    types: ['REQUEST', {
        type: 'SUCCESS',
        payload: (action, state, res) => {
          return getJSON(res).then((json) => normalize(json, { campaigns: [campaignSchema] }));
        }
      }, 'FAILURE']
  }
})

export const getInboxes = () => ({
  [CALL_API]: {
    endpoint: `/inboxes`,
    method: 'GET',
    credentials: 'same-origin',
    types: ['REQUEST', {
        type: 'SUCCESS',
        payload: (action, state, res) => {
          return getJSON(res).then((json) => normalize(json, { inboxes: [inboxSchema] }));
        }
      }, 'FAILURE']
  }
})
