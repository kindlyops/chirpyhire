import 'react-select/dist/react-select.css'
import 'react-virtualized/styles.css'

import React from 'react'
import ReactDOM from 'react-dom'

import Root from '../containers/root'
import store from '../store'
import history from '../store/history'

document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('app-container')
  ReactDOM.render(<Root store={store} history={history} />, node)
})


