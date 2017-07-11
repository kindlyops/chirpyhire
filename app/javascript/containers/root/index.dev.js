import React from 'react'
import DevTools from '../DevTools'
import { Provider } from 'react-redux'
import { ConnectedRouter } from 'react-router-redux'
import { Route } from 'react-router'

import Application from '../application'

const Root = ({ store, history }) => (
  <Provider store={store}>
    <div>
      <ConnectedRouter history={history}>
        <Route path="/" component={Application} />
      </ConnectedRouter>
      <DevTools />
    </div>
  </Provider>
)

export default Root;
