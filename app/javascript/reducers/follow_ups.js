import { combineReducers } from 'redux'
import { allIds } from './allIds'
import { byId } from './byId'

const follow_ups = combineReducers({
  byId: byId('follow_ups'),
  allIds: allIds('follow_ups')
})

export default follow_ups
