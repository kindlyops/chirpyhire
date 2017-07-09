import { combineReducers } from 'redux'

import { routerReducer as router } from 'react-router-redux'
import { reducer as form } from 'redux-form'

import greetings from './greetings'
import follow_ups from './follow_ups'
import questions from './questions'
import goals from './goals'
import bots from './bots'
import campaigns from './campaigns'
import inboxes from './inboxes'

const entities = combineReducers({
  greetings,
  follow_ups,
  questions,
  goals,
  bots,
  campaigns,
  inboxes
})

const rootReducer = combineReducers({
  entities,
  router,
  form
});

export default rootReducer
