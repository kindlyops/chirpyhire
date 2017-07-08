import { createStore, applyMiddleware } from 'redux'
import { routerMiddleware } from 'react-router-redux'
import rootReducer from '../reducers'

import history from './history'
const middleware = routerMiddleware(history)

const configureStore = preloadedState => createStore(
  rootReducer,
  preloadedState,
  applyMiddleware(middleware)
)

export default configureStore
