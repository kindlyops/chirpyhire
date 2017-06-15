/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb
import 'react-select/dist/react-select.css'
import 'react-virtualized/styles.css'

import React from 'react'
import ReactDOM from 'react-dom'
import {
  BrowserRouter as Router,
  Route,
  Switch
} from 'react-router-dom'

import Inbox from 'inbox'
import Platform from 'platform'

const App = app => (
  <Router>
    <div>
      <Switch>
        <Route path="/candidates" render={props => <Platform inboxId={app.inboxId} {...props} />} />
        <Route path="/inboxes/:inboxId/conversations/:id" component={Inbox} />
        <Route path="/inboxes/:inboxId/conversations" component={Inbox} />
      </Switch>
    </div>
  </Router>
)

document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('app-container')
  const data = R.merge({}, node.dataset);

  ReactDOM.render(<App {...data}/>, node)
})



