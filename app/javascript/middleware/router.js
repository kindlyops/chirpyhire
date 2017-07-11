import history from '../store/history'
import { routerMiddleware } from 'react-router-redux'

export default routerMiddleware(history);
