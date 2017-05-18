import React, { Component } from 'react'
import { Field, reduxForm } from 'redux-form'
import Icon from '../Icon'

class SearchForm extends Component {
  constructor(props) {
    super(props)
    this.handleChange = this.handleChange.bind(this)
  }

  handleChange({target: {value}}) {
    switch(value){
      case '':
        return this.props.handleChange({})
      default:
        return this.props.handleChange({topic: value})
    }
  }

  render() {
    const { handleSubmit, isDrawerOpen } = this.props
    return (
      <form onSubmit={handleSubmit}>
        <div className="chat-aside__input c-input c-input--flat" style={(isDrawerOpen && {visibility: "none"})|| {}}>
          <label className="c-input-wrapper">
            <Icon name="search"/>
            <Field name="query" onChange={this.handleChange} placeholder="Type something" className="c-input__control" component="input" type="search" autoComplete="off"/>
          </label>
        </div>
      </form>
    );
  }
}

SearchForm = reduxForm({
  form: 'searchRoom'
})(SearchForm)

export default SearchForm
