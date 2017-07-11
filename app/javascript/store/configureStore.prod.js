import { createStore, applyMiddleware } from 'redux'
import rootReducer from '../reducers'
import router from '../middleware/router'
import { apiMiddleware } from 'redux-api-middleware'

const configureStore = preloadedState => createStore(
  rootReducer,
  preloadedState,
  applyMiddleware(router, apiMiddleware)
)

export default configureStore
