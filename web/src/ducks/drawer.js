const OPEN_DRAWER      = 'grook/drawer/OPEN_DRAWER'
const CLOSE_DRAWER     = 'grook/drawer/CLOSE_DRAWER'

const initialState = {
  isOpen: false,
  title: "",
  component: null
}

export default function reducer(state = initialState, action) {
  switch(action.type){
    case OPEN_DRAWER:
      return {...state, isOpen: true, title: action.title, component: action.component}
    case CLOSE_DRAWER:
      return {...state, isOpen: false, title: "", component: null}
    default: return state
  }
}

export function openDrawer(title, component) {
  return (dispatch) => {
    return dispatch({
      type: OPEN_DRAWER,
      title: title,
      component: component
    })
  }
}

export function closeDrawer() {
  return (dispatch) => {
    return dispatch({type: CLOSE_DRAWER})
  }
}
