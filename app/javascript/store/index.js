import { createStore, combineReducers, applyMiddleware } from 'redux'
import { reducer as formReducer } from 'redux-form'

import { routerReducer, routerMiddleware } from 'react-router-redux'

import history from './history'

const middleware = routerMiddleware(history)

const store = createStore(
  combineReducers({
    router: routerReducer,
    form: formReducer
  }),
  applyMiddleware(middleware)
);

export default store
