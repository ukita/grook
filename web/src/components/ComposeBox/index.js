import React, { Component } from 'react'
import ReactQuill from 'react-quill'
import { Field, reduxForm } from 'redux-form'
import Icon from '../Icon'
import '../../../node_modules/react-quill/dist/quill.core.css'
import './style.css'

class ComposeBox extends Component {
  constructor(props) {
    super(props)
    this.handleChange = this.handleChange.bind(this)
    this.state = { value: '' }
    this.modules = {
      toolbar: false,
      keyboard: {
        bindings: { 
          handleEnter: {
            key: 13,
            handler: () => {
              this.props.onSubmitQuill()
              this.setState({value: ''})
            }
          }
        }
      }
    }
  }

  handleChange(value) {
    this.setState({value: value})
    this.props.change("post[message]", value)
  }

  render() {
    const { handleSubmit, openDialog, attachments } = this.props
    return (
      <footer>
        <form className="chat-footer" onSubmit={handleSubmit}>
          <ReactQuill modules={this.modules} value={this.state.value} onChange={this.handleChange} placeholder="Type something" theme="default">
            <div className="chat-footer__box">
              <Field name="post[message]" component="input" type="hidden"/>
            </div>
          </ReactQuill>
          <div className="chat-footer__upload" onClick={openDialog}>
            <Icon name="upload"/>
          </div>
        </form>
        <div className="chat-footer__attachments">
          {attachments.map((attachment, i) => {
            return (
              <div className="chat-footer__attachments__items" key={i} style={{backgroundImage: `url(${attachment.file.original})`}}/>
            )
          })}
        </div>
      </footer>
    )
  }
}

export default reduxForm({
  form: 'composeBox'
})(ComposeBox) 
