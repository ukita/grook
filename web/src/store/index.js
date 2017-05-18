import { createStore, applyMiddleware } from 'redux'
import reducers from '../ducks/index'
import thunkMiddleware from 'redux-thunk'
import { createLogger } from 'redux-logger'

const loggerMiddleware = createLogger()

export default function configureStore(preloadedState) {
  return createStore(
    reducers,
    preloadedState,
    applyMiddleware(
      thunkMiddleware,
      loggerMiddleware
    )
  )
}
