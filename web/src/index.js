import React from 'react'
import ReactDOM from 'react-dom'
import { Provider } from 'react-redux'
import configureStore from './store'
import Chat from './containers/Chat'
import './index.css'

const store = configureStore()

ReactDOM.render(
  <Provider store={ store }>
    <Chat/>
  </Provider>,
  document.getElementById('root')
)
