import { combineReducers } from 'redux'
import { allIds } from './allIds'
import { byId } from './byId'

const campaigns = combineReducers({
  byId: byId('campaigns'),
  allIds: allIds('campaigns')
})

export default campaigns
