import { combineReducers } from 'redux'
import { allIds } from './allIds'
import { byId } from './byId'

const inboxes = combineReducers({
  byId: byId('inboxes'),
  allIds: allIds('inboxes')
})

export default inboxes
