import React, { Component } from 'react'
import { connect } from 'react-redux'
import { fetchRooms, createRoom, searchRooms } from '../../ducks/room'
import { selectRoom } from '../../ducks/conversation'
import { openDrawer } from '../../ducks/drawer'
import DrawerManager from '../DrawerManager'
import RoomForm from '../../components/RoomForm'
import SearchForm from '../../components/SearchForm'
import Room from '../../components/Room'
import './style.css'

class RoomlistPanel extends Component {
  constructor(props) {
    super(props)
    this.openRoomForm = this.openRoomForm.bind(this)
  }

  componentDidMount() {
    this.props.fetchRooms()
  }

  openRoomForm() {
    this.props.openDrawer(
      "New Room", 
      <RoomForm onSubmit={this.props.createRoom}/>
    )
  }

  render(){
    const { isDrawerOpen, rooms, currentUser, searchRooms } = this.props
    return (
      <aside className="chat-aside">
        <DrawerManager/>
        <SearchForm isDrawerOpen={isDrawerOpen} handleChange={searchRooms}/>
        <nav className="card-list">
          { rooms.map((room, i) => {
            return <Room key={i} currentUser={currentUser} room={room} active={room === this.props.selectedRoom} handleClick={this.props.selectRoom}/>
          })}
        </nav>
        <button className="chat-aside__button-floated c-btn c-btn--rounded c-btn--secondary" onClick={this.openRoomForm}>Create a new Room</button>
      </aside>
    )
  }
}

function mapStateToProps(state) {
  const { currentUser } = state.auth
  const { isFetchingRoom, rooms } = state.room
  const { room } = state.conversation
  const { isOpen } = state.drawer
  
  return {
    currentUser,
    isFetchingRoom,
    rooms,
    isDrawerOpen: isOpen,
    selectedRoom: room
  }
}

export default connect(mapStateToProps, {
  fetchRooms, 
  openDrawer, 
  createRoom, 
  selectRoom,
  searchRooms
})(RoomlistPanel)
