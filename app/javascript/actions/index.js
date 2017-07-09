import { CALL_API, getJSON } from 'redux-api-middleware';
import { normalize } from 'normalizr';
import { 
  arrayOfBotsSchema, arrayOfInboxesSchema, arrayOfCampaignsSchema,
  botSchema
} from './schema';

const SUCCESS = '@@congaree/SUCCESS';
const REQUEST = '@@congaree/REQUEST';
const FAILURE = '@@congaree/FAILURE';

export const updateBot = (bot) => ({
  type: SUCCESS, 
  payload: normalize(bot, botSchema)
});

export const getBots = () => ({
  [CALL_API]: {
    endpoint: `/bots`,
    method: 'GET',
    credentials: 'same-origin',
    types: [REQUEST, {
        type: SUCCESS,
        payload: (action, state, res) => {
          return getJSON(res).then((json) => normalize(json, arrayOfBotsSchema));
        }
      }, FAILURE]
  }
})

export const getBot = (id) => ({
  [CALL_API]: {
    endpoint: `/bots/${id}`,
    method: 'GET',
    credentials: 'same-origin',
    types: [REQUEST, {
        type: SUCCESS,
        payload: (action, state, res) => {
          return getJSON(res).then((json) => normalize(json, botSchema));
        }
      }, FAILURE]
  }
})

export const getCampaigns = () => ({
  [CALL_API]: {
    endpoint: `/campaigns`,
    method: 'GET',
    credentials: 'same-origin',
    types: [REQUEST, {
        type: SUCCESS,
        payload: (action, state, res) => {
          return getJSON(res).then((json) => normalize(json, arrayOfCampaignsSchema));
        }
      }, FAILURE]
  }
})

export const getInboxes = () => ({
  [CALL_API]: {
    endpoint: `/inboxes`,
    method: 'GET',
    credentials: 'same-origin',
    types: [REQUEST, {
        type: SUCCESS,
        payload: (action, state, res) => {
          return getJSON(res).then((json) => normalize(json, arrayOfInboxesSchema));
        }
      }, FAILURE]
  }
})
