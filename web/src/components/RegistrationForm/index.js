import React, { Component } from 'react'
import { Field, reduxForm } from 'redux-form'
import Input from '../Input'

class RegistrationForm extends Component {
  render() {
    const { handleSubmit, submitting } = this.props
    return (
      <form onSubmit={handleSubmit}>
        <Field name="user[name]" label="Name" component={Input} type="text" props={{required: true}}/>
        <Field name="user[username]" label="Username" component={Input} type="text" props={{required: true}}/>
        <Field name="user[email]" label="Email" component={Input} type="email" props={{required: true}}/>
        <Field name="user[password]" label="Password" component={Input} type="password" props={{required: true}}/>
        <Field name="user[password_confirmation]" label="Password confirmation" component={Input} type="password" props={{required: true}}/>
        <div className="c-form-group">
          <button type="submit" disabled={submitting} className="c-btn c-btn--rounded c-btn--primary c-btn--block">Sign up</button>
        </div>
      </form>
    );
  }
}

RegistrationForm = reduxForm({
  form: 'registration'
})(RegistrationForm)

export default RegistrationForm
