import { combineReducers } from 'redux'

import { routerReducer as router } from 'react-router-redux'
import { reducer as form } from 'redux-form'

const rootReducer = combineReducers({
  router,
  form
});

export default rootReducer
