import { submit, reset } from 'redux-form'
import emojione from 'emojione'
import moment from 'moment'

const SELECT_ROOM            = 'grook/conversation/SELECT_ROOM'
const REQUEST_POSTS          = 'grook/conversation/REQUEST_POSTS'
const RECEIVE_POSTS          = 'grook/conversation/RECEIVE_POSTS'
const RECEIVE_POST           = 'grook/conversation/RECEIVE_POST'
const USER_LEFT_ROOM         = 'grook/conversation/USER_LEFT_ROOM'
const CONNECTED_ROOM_CHANNEL = 'grook/conversation/CONNECTED_ROOM_CHANNEL'
const SENDING_ATTACHMENTS    = 'grook/conversation/SENDING_ATTACHMENTS'
const RECEIVE_ATTACHMENTS    = 'grook/conversation/RECEIVE_ATTACHMENTS'
const CLEAN_ATTACHMENTS      = 'grook/conversation/CLEAN_ATTACHMENTS'
const EXIT_ROOM              = 'grook/conversation/EXIT_ROOM'

const initialState = {
  room: null,
  channel: null,
  isFetchingPosts: false,
  isSendingAttachment: false,
  posts: [],
  attachments: []
}

export default function reducer(state = initialState, action = {}) {
  switch (action.type){
    case SELECT_ROOM:
      return {...state, room: action.room}
    case CONNECTED_ROOM_CHANNEL:
      return {...state, channel: action.channel, isFetchingPosts: false, posts: action.json.posts}
    case REQUEST_POSTS:
      return {...state, isFetchingPosts: true}
    case RECEIVE_POST:
      return {...state, posts: [...state.posts, action.json.post]}
    case USER_LEFT_ROOM:
      return {...initialState, room: state.room}
    case SENDING_ATTACHMENTS:
      return {...state, isSendingAttachment: true}
    case RECEIVE_ATTACHMENTS:
      return {...state, isSendingAttachment: false, attachments: [...state.attachments, action.json.attachment]}
    case CLEAN_ATTACHMENTS:
      return {...state, attachments: []}
    case EXIT_ROOM:
      return {...initialState}
    default: return state
  }
}

export function connectToRoomChannel() {
  return (dispatch, getState) => {
    const { auth: { socket }, conversation: { room }} = getState()
    const channel = socket.channel(`room:${room.id}`)

    channel.on("post_created", json => {
      channel.params.last_seen_post = moment(json.post.created_at).format('x')
      dispatch({type: RECEIVE_POST, json})
    })

    channel.join()
      .receive("ok", json => {
        let posts = json.posts.map(post => moment(post.created_at).format('x'))
        if(posts.length > 0){ channel.params.last_seen_post = Math.max(...posts) }
        dispatch({type: CONNECTED_ROOM_CHANNEL, json, channel})
      })
      .receive("error", reason => {
        console.log("join failed", reason)
      })

    return true
  }
}

export function leaveRoomChannel() {
  return (dispatch, getState) => {
    const { conversation: { channel } } = getState()
    if(channel) {
      channel.leave()
    }
    return dispatch({type: USER_LEFT_ROOM})
  }
}

export function exitRoom() {
  return (dispatch, getState) => {
    const { conversation: { channel } } = getState()
    if(channel) {
      channel.leave()
    }
    return dispatch({type: EXIT_ROOM})
  }
}

export function selectRoom(room) {
  return (dispatch) => {
    return dispatch({type: SELECT_ROOM, room})
  }
}

export function fetchPosts() {
  return (dispatch, getState) => {
    const { auth: { token }, conversation: { room }} = getState()

    dispatch({type: REQUEST_POSTS})
    return fetch(`/api/rooms/${room.id}/posts`, {headers: {'content-type': 'application/json', Authorization: `Bearer ${token}`}})
      .then(response => response.json())
      .then(json => dispatch({type: RECEIVE_POSTS, json}))
  }
}

export function createPost(data) {
  return (dispatch, getState) => {
    const { conversation: { channel, attachments } } = getState()

    new Promise((resolve, reject) => {
      channel.push(
        'new_post', 
        buildPostMessage(data, attachments)
      )
      .receive('ok', () => {
        dispatch({type: CLEAN_ATTACHMENTS})
        resolve(dispatch(reset('composeBox')))
      })
      .receive('error', () => reject())
    })
  }
}

export function onSubmitQuill() {
  return (dispatch) => {
    return dispatch(submit('composeBox'))
  }
}

export function createAttachments(data){
  return (dispatch, getState) => {
    const { auth: { token } } = getState()

    dispatch({type: SENDING_ATTACHMENTS})

    let files = new FormData()
    files.append('attachment[file]', data[0])

    return fetch(`api/posts/attachments`, {headers: {Authorization: `Bearer ${token}`}, method: 'POST', body: files})
      .then(response => response.json())
      .then(json => dispatch({type: RECEIVE_ATTACHMENTS, json}))
  }
}

function buildPostMessage(data, attachments) {
  return { 
    post: {
      ...data.post, 
      message: emojione.toImage(data.post.message),
      attachments: attachments.map((attachment) => attachment.id)
    }
  }
}
