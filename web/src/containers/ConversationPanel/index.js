import React, { Component } from 'react'
import { connect } from 'react-redux'
import Dropzone from 'react-dropzone'
import { connectToRoomChannel, onSubmitQuill, createPost, leaveRoomChannel, createAttachments } from '../../ducks/conversation'
import ComposeBox from '../../components/ComposeBox'
import PostList from '../../components/PostList'
import './style.css'

class ConversationPanel extends Component {
  constructor(props) {
    super(props)
    this.dropzoneRef = null
    this.onDrop = this.onDrop.bind(this)
  }

  componentDidMount() {
    this.props.connectToRoomChannel()
  }

  onDrop(file) {
    if(file.length !== 0){
      this.props.createAttachments(file)
    }
  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.room.id !== this.props.room.id) {
      this.props.leaveRoomChannel()
      this.props.connectToRoomChannel()
    }
  }

  render() {
    const { room, posts, currentUser, attachments } = this.props

    return (
      <Dropzone ref={(ref) => { this.dropzoneRef = ref }} 
                onDropAccepted={this.onDrop}
                accept="image/*"
                multiple={false}
                style={{}} 
                disableClick
                disablePreview
                className="chat-container">
        {/* Chat Header */}
        <header key={room.id} className="chat-header">
          <figure className="chat-header-figure">
            <img src={`https://api.adorable.io/avatars/200/${room.id}`} alt={room.topic} className="chat-header-figure__img h-img-rounded" />
          </figure>
          <div className="chat-header__text-wrapper">
            <h2>{room.topic}</h2>
            <p className="h-text-overflow">{room.description}</p>
          </div>
          <div className="grouped-images">
            {room.members.map((member, i) => {
              return (
                <figure key={i} className="grouped-images__items">
                  <img src={`https://api.adorable.io/avatars/200/${member.id}`} alt={member.name} className="chat-header-figure__img h-img-rounded" />
                </figure>
              )
            })}
          </div>
        </header>
        {/* end Chat Header */}
        <PostList posts={posts} currentUser={currentUser}/>
        <ComposeBox 
          onSubmit={this.props.createPost} 
          onSubmitQuill={this.props.onSubmitQuill} 
          openDialog={() => this.dropzoneRef.open()}
          attachments={attachments}
        />
      </Dropzone>
    )
  }
}

function mapStateToProps(state) {
  const { currentUser } = state.auth
  const { room, posts, attachments } = state.conversation

  return {
    currentUser,
    room,
    posts,
    attachments
  }
}

export default connect(mapStateToProps, { 
  connectToRoomChannel, 
  onSubmitQuill, 
  createPost,
  leaveRoomChannel,
  createAttachments
})(ConversationPanel)
