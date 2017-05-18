import React, { Component } from 'react'
import { Field, reduxForm } from 'redux-form'
import Input from '../Input'

class RoomForm extends Component {
  render() {
    const { handleSubmit, submitting } = this.props
    return (
      <form onSubmit={handleSubmit}>
        <Field name="room[topic]" label="Topic" component={Input} type="text" props={{required: true}}/>
        <Field name="room[description]" label="Description" component={Input} type="textarea"/>
        <div className="c-form-group">
          <button type="submit" disabled={submitting} className="c-btn c-btn--rounded c-btn--primary c-btn--block">Create room</button>
        </div>
      </form>
    );
  }
}

RoomForm = reduxForm({
  form: 'room'
})(RoomForm)

export default RoomForm
