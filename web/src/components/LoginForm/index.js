import React, { Component } from 'react'
import { Field, reduxForm } from 'redux-form'
import Input from '../Input'

class LoginForm extends Component {
  render() {
    const { handleSubmit, submitting, error } = this.props
    return (
      <form onSubmit={handleSubmit}>
        {error && <span className="c-form-error">{error}</span>}
        <Field name="user[username]" label="Username" className="c-input__control" component={Input} type="text"/>
        <Field name="user[password]" label="Password" className="c-input__control" component={Input} type="password"/>
        <div className="c-form-group">
          <button type="submit" disabled={submitting} className="c-btn c-btn--rounded c-btn--primary c-btn--block">Sign in</button>
        </div>
      </form>
    );
  }
}

LoginForm = reduxForm({
  form: 'login'
})(LoginForm)

export default LoginForm
