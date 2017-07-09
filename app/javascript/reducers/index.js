import { combineReducers } from 'redux'

import { routerReducer as router } from 'react-router-redux'
import { reducer as form } from 'redux-form'

const entities = (state = { 
  greetings: {}, follow_ups: {}, questions: {}, goals: {}, bots: {}, 
  campaigns: {}, inboxes: {} }, action) => {
  if (action.response && action.response.entities) {
    return R.mergeAll([{}, state, action.response.entities])
  }

  return state
}

const rootReducer = combineReducers({
  entities,
  router,
  form
});

export default rootReducer
