import React, { Component } from 'react'
import './style.css'

class Room extends Component {
  constructor(props){
    super(props)
    this.getDescription = this.getDescription.bind(this)
    this.handleClick = this.handleClick.bind(this)
  }

  getDescription() {
    const { lastMessage, description } = this.props.room
    if(lastMessage) return `${lastMessage.user}: ${lastMessage.message}`

    return description
  }

  handleClick() {
    this.props.handleClick(this.props.room)
  }

  render(){
    const {room, active, currentUser} = this.props
    return (
      <div key={room.id} className={`card-chat ${active ? 'is-active' : ''}`} onClick={this.handleClick}>
        <figure className="card-chat-figure">
          <img src={`https://api.adorable.io/avatars/200/${room.id}`} alt={room.topic} className="card-chat-figure__img h-img-rounded" />
          {/*<label className="card-chat-counter c-label c-label--primary">1</label>*/}
        </figure>
        <div className="card-chat__text-wrapper">
          <h2 className="card-chat-title h-text-overflow">{room.topic}</h2>
          <p className="card-chat-text h-text-overflow">{this.getDescription()}</p>
        </div>
        {/*<time className="card-chat-label c-label c-label--primary c-label--big">10min</time>*/}
        {/* Actions */}
        <ul className="c-list-actions c-list-actions--top-right">
          <li className="c-list-actions__item">
            <div className="c-action has-dropdown">
              <svg className="c-action__icon">
                <use xlinkHref="#caret-down"></use>
              </svg>
              <ul className="c-dropdown c-dropdown--scale c-dropdown--right">
                {currentUser.id === room.owner_id && 
                  <li className="c-dropdown__item"><a href="#" className="c-dropdown-action">Invite</a></li>
                }
                <li className="c-dropdown__item"><a href="#" className="c-dropdown-action">Leave room</a></li>
              </ul>
            </div>
          </li>
        </ul>
        {/* end Actions */}
      </div>
    )
  }
}

export default Room
