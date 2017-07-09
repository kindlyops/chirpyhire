import { combineReducers } from 'redux'
import { allIds } from './allIds'
import { byId } from './byId'

const goals = combineReducers({
  byId: byId('goals'),
  allIds: allIds('goals')
})

export default goals
