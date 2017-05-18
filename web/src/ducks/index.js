import { combineReducers } from 'redux'
import { reducer as formReducer } from 'redux-form'
import { reducer as notificationsReducer } from 'reapop'
import auth from './auth'
import room from './room'
import drawer from './drawer'
import conversation from './conversation'

export default combineReducers({
  form: formReducer,
  notifications: notificationsReducer(),
  auth,
  room,
  drawer,
  conversation
})
