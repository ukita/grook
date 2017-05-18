import React, { Component } from 'react'
import { connect } from 'react-redux'
import NotificationsSystem from 'reapop'
import theme from 'reapop-theme-wybo'
import { getCurrentUser } from '../../ducks/auth'
import App from '../../components/App'
import RoomlistPanel from '../RoomlistPanel'
import ConversationPanel from '../ConversationPanel'
import Auth from '../Auth'

class Chat extends Component {
  componentDidMount() {
    const token = localStorage.getItem('token')
    if(token){
      this.props.getCurrentUser(token)
    }
  }

  render() {
    const { isAuthenticated, isFetchingUser, selectedRoom } = this.props
    if(isFetchingUser) return <div>Loading...</div>
    if(!isAuthenticated){
      return (
        <App>
          <NotificationsSystem theme={theme}/>
          <Auth/>
        </App>
      )
    }
    
    return (
      <App>
        <NotificationsSystem theme={theme}/>
        <RoomlistPanel key="roomlist"/>
        {selectedRoom && <ConversationPanel key="conversation"/>}
        {!selectedRoom && <div className="chat-container"></div>}
      </App>
    )
  }
}

function mapStateToProps(state) {
  const { isAuthenticated, isFetchingUser } = state.auth
  const { room } = state.conversation
  
  return {
    isAuthenticated,
    isFetchingUser,
    selectedRoom: room
  }
}

export default connect(mapStateToProps, {getCurrentUser})(Chat)
