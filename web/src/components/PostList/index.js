import React, { Component } from 'react'
import moment from 'moment'
import Icon from '../../components/Icon'
import './style.css'

class PostList extends Component {
  constructor(props){
    super(props)
    this.container = null;
    this.state = { lastUserId: null } 
    this.renderAttachments = this.renderAttachments.bind(this)
  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.posts.length !== this.props.posts.length) {
      this.scrollToBottom()
    }
  }

  maybeScrollToBottom() {
    if (this.container.scrollHeight - this.container.scrollTop < this.container.clientHeight + 50) {
      this.scrollToBottom()
    }
  }

  scrollToBottom() {
    setTimeout(() => { this.container.scrollTop = this.container.scrollHeight })
  }

  stringToColor(str) {
    let baseRed   = 120
    let baseGreen = 110
    let baseBlue  = 100

    let seed   = str.charCodeAt(0) ^ str.charCodeAt(1)
    let rand_1 = Math.abs((Math.sin(seed++) * 10000)) % 256
    let rand_2 = Math.abs((Math.sin(seed++) * 10000)) % 256
    let rand_3 = Math.abs((Math.sin(seed++) * 10000)) % 256

    let red = Math.round((rand_1 + baseRed) / 2)
    let green = Math.round((rand_2 + baseGreen) / 2)
    let blue = Math.round((rand_3 + baseBlue) / 2)

    return `rgb(${red}, ${green}, ${blue})`
  }

  renderAttachments(post) {
    const { currentUser } = this.props 
    return post.attachments.map((attachment, i) => {
        return (
          <div key={i} className={"chat-msg " + (post.user.id === currentUser.id ? "chat-msg--sent" : "chat-msg--received")}>
            <div className="chat-msg__content">
              <div key={i} className="msg-attachment">
                <div className="msg-attachment__thumbnail" alt={attachment.name} style={{backgroundImage: `url(${attachment.file.original})`}}/>
                <a className="msg-attachment__details" download={attachment.name} href={attachment.file.original}>
                  <Icon className="msg-attachment__zoom" name="download"/>
                </a>
              </div>
            </div>
          </div>
        )
    })
  }

  render() {
    const { posts, currentUser } = this.props
    let lastUserId = null
    return (
      <div className="chat-body" ref={(c) => this.container = c}>
        {posts.map((post, i) => {
          let content = (
            <div key={i} className={"chat-msg " + (post.user.id === currentUser.id ? "chat-msg--sent" : "chat-msg--received")}>
              {lastUserId !== post.user.id && 
                <div className="chat-msg-header">
                  <p className="chat-msg-header__title" style={{color: this.stringToColor(post.user.id)}}>{post.user.name}</p>
                </div>
              }
              <div className="chat-msg__content" dangerouslySetInnerHTML={{__html: post.message}}/>
              <div className="chat-msg__footer">
                <time>{moment(post.created_at).format('HH:MM')}</time>
              </div>
            </div>
          )
          lastUserId = post.user.id
          return [content, this.renderAttachments(post)]
        })}
      </div>
    )
  }
}

export default PostList
