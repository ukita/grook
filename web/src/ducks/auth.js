import { reset, SubmissionError} from 'redux-form'
import { Socket } from 'phoenix'
import {addNotification as notify} from 'reapop'

const AUTHENTICATION_SUCCESS = 'grook/auth/AUTHENTICATION_SUCCESS'
const AUTHENTICATION_FAILURE = 'grook/auth/AUTHENTICATION_FAILURE'
const RECEIVE_USER           = 'grook/auth/RECEIVE_USER'
const REQUEST_USER           = 'grook/auth/REQUEST_USER'
const REGISTRATION_REQUEST   = 'grook/auth/REGISTRATION_REQUEST'
const REGISTRATION_SUCCESS   = 'grook/auth/REGISTRATION_SUCCESS'
const REGISTRATION_FAILURE   = 'grook/auth/REGISTRATION_FAILURE'
const CHANGE_ACTIVE_TAB      = 'grook/auth/CHANGE_ACTIVE_TAB'
const SOCKET_CONNECTED       = 'grook/auth/SOCKET_CONNECTED'

export const SIGN_IN_TAB = 'SIGN_IN_TAB'
export const SIGN_UP_TAB = 'SIGN_UP_TAB'

const initialState = {
  currentUser: {},
  isAuthenticated: false,
  isFetchingUser: false,
  isRegisteringUser: false,
  token: null,
  socket: null,
  activeTab: 'SIGN_IN_TAB'
}

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case AUTHENTICATION_SUCCESS:
      return {...state, isAuthenticated: true, token: action.json.token.jwt}
    case AUTHENTICATION_FAILURE:
      return {...initialState}
    case RECEIVE_USER:
      return {...state, isAuthenticated: true, isFetchingUser: false, currentUser: action.json.user}
    case REQUEST_USER:
      return {...state, isFetchingUser: true, token: action.token}
    case REGISTRATION_REQUEST:
      return {...state, isRegisteringUser: true}
    case REGISTRATION_SUCCESS:
      return {...state, isRegisteringUser: false, activeTab: SIGN_IN_TAB}
    case REGISTRATION_FAILURE:
      return {...state, isRegisteringUser: false}
    case CHANGE_ACTIVE_TAB:
      return {...state, activeTab: action.tab}
    case SOCKET_CONNECTED:
      return {...state, socket: action.socket}
    default: return state
  }
}

function connectToSocket(dispatch) {
  const token = localStorage.getItem('token');
  const socket = new Socket(`/socket`, {params: {guardian_token: token}})
  socket.connect()
  
  dispatch({type: SOCKET_CONNECTED, socket})
}

export function login(data) {
  return (dispatch) => fetch('/api/tokens', { method: 'POST', headers: {'content-type': 'application/json'}, body: JSON.stringify(data) })
    .then(parseResponse)
    .then(json => {
      localStorage.setItem('token', json.token.jwt)
      dispatch(reset('registration'))
      connectToSocket(dispatch)
      dispatch({type: AUTHENTICATION_SUCCESS, json})
    })
    .catch((response) => {
      authenticationFailure(dispatch)
      throw new SubmissionError({_error: 'Invalid username or password'})
    })
}

export function signup(data) {
  return (dispatch) => {
    dispatch({type: REGISTRATION_REQUEST})
    return fetch('/api/users', { method: 'POST', headers: {'content-type': 'application/json'}, body: JSON.stringify(data) })
      .then(parseResponse)
      .then(json => {
        dispatch(notify({message: "User created succesfully", status: "success"}))
        dispatch({type: REGISTRATION_SUCCESS})
      })
      .catch((response) => {
        dispatch({type: REGISTRATION_FAILURE})
        throw new SubmissionError({user: response.errors})
      })
  }
}

export function changeTab(tab) {
  return (dispatch) => {
    return dispatch({type: CHANGE_ACTIVE_TAB, tab})
  }
}

export function getCurrentUser(token) {
  return (dispatch) => {
    dispatch({type: REQUEST_USER, token})
    return fetch('/api/me', {headers: {'content-type': 'application/json', Authorization: `Bearer ${token}`}})
      .then(parseResponse)
      .then(json => setCurrentUser(dispatch, json))
      .catch(response => authenticationFailure(dispatch))
  }
}

function setCurrentUser(dispatch, json) {
  connectToSocket(dispatch)
  return dispatch({type: RECEIVE_USER, json})
}

function authenticationFailure(dispatch){
  dispatch(reset('login'))
  return dispatch({type: AUTHENTICATION_FAILURE})
}

function parseResponse(response) {
  return response.json().then((json) => {
    if (response.ok) return json
    
    return Promise.reject(json)
  })
}
