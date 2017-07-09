import React from 'react'

import { Provider } from 'react-redux'
import { ConnectedRouter } from 'react-router-redux'
import { Route } from 'react-router'

import Application from '../application'

const Root = ({ store, history }) => (
  <Provider store={store}>
    <ConnectedRouter history={history}>
      <Route path="/" component={Application} />
    </ConnectedRouter>
  </Provider>
)

export default Root;
