import React, { Component } from 'react'
import './style.css'

class Input extends Component {
  render() {
    const { input, label, type, required, meta: { touched, error } } = this.props
    return (
      <div className="c-form-group">
        <div className="c-input c-input--flat">
          <label className="c-input-wrapper">
            <input {...input} className="c-input__control" placeholder={label} type={type} required={required}/>
          </label>
        </div>
        {touched && error && <span className="c-input__error">{error}</span>}
      </div>
    )
  }
}

export default Input
