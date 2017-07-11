import { combineReducers } from 'redux'
import { allIds } from './allIds'
import { byId } from './byId'

const tags = combineReducers({
  byId: byId('tags'),
  allIds: allIds('tags')
})

export default tags
