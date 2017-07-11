import { combineReducers } from 'redux'
import { allIds } from './allIds'
import { byId } from './byId'

const bots = combineReducers({
  byId: byId('bots'),
  allIds: allIds('bots')
})

export default bots
