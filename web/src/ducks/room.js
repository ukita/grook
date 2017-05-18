import { closeDrawer } from './drawer'
import { exitRoom } from './conversation'

const ADD_ROOM        = 'grook/room/ADD_ROOM'
const INSERTING_ROOM  = 'grook/room/INSERTING_ROOMS'
const REQUEST_ROOMS   = 'grook/room/REQUEST_ROOMS'
const RECEIVE_ROOMS   = 'grook/room/RECEIVE_ROOMS'
const SEARCH_ROOMS    = 'grook/room/SEARCH_ROOMS'

const initialState = {
  rooms: [],
  isFetchingRoom: false,
  isInsertingRoom: false,
  isSearchingRooms: false,
}

export default function reducer(state = initialState, action = {}) {
  switch (action.type){
    case ADD_ROOM:
      return {...state, isFetchingRoom: false, rooms: [...state.rooms, action.json.room]}
    case REQUEST_ROOMS:
      return {...state, isFetchingRoom: true}
    case RECEIVE_ROOMS:
      return {...state, isFetchingRoom: false, isSearchingRooms: false, rooms: action.json.rooms}
    case INSERTING_ROOM:
      return {...state, isInsertingRoom: true}
    case SEARCH_ROOMS:
      return {...state, isSearchingRooms: true}
    default: return state
  }
}

export function fetchRooms() {
  return (dispatch, getState) => {
    const { auth: { token } } = getState()

    dispatch({type: REQUEST_ROOMS})
    return fetch('/api/rooms', {headers: {'content-type': 'application/json', Authorization: `Bearer ${token}`}})
      .then(response => response.json())
      .then(json => dispatch({type: RECEIVE_ROOMS, json}))
  }
}

export function createRoom(data) {
  return (dispatch, getState) => {
    const { auth: { token } } = getState()

    dispatch({type: INSERTING_ROOM})
    return fetch('/api/rooms', {method: 'POST', headers: {'content-type': 'application/json', Authorization: `Bearer ${token}`}, body: JSON.stringify(data)})
      .then(response => response.json())
      .then(json => {
        dispatch({type: ADD_ROOM, json})
        dispatch(closeDrawer())
      })
  }
}

export function searchRooms(query) {
  return (dispatch, getState) => {
    const { auth: { token } } = getState()

    dispatch({type: SEARCH_ROOMS})
    dispatch(exitRoom())
    return fetch(`/api/rooms${queryString(query)}`, {headers: {'content-type': 'application/json', Authorization: `Bearer ${token}`}})
      .then(response => response.json())
      .then(json => dispatch({type: RECEIVE_ROOMS, json}))
  }
}

function queryString(params) {
  const query = 
    Object.keys(params)
      .map((k) => `${encodeURIComponent(k)}=${encodeURIComponent(params[k])}`)
      .join('&');
  return `${query.length ? '?' : ''}${query}`;
}
