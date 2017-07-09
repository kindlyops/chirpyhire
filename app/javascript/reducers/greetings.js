import { combineReducers } from 'redux'
import { allIds } from './allIds'
import { byId } from './byId'

const greetings = combineReducers({
  byId: byId('greetings'),
  allIds: allIds('greetings')
})

export default greetings
