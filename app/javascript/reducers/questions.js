import { combineReducers } from 'redux'
import { allIds } from './allIds'
import { byId } from './byId'

const questions = combineReducers({
  byId: byId('questions'),
  allIds: allIds('questions')
})

export default questions
