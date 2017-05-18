import React, { Component } from 'react'
import './style.css'

class Logo extends Component {
  render(){
    const { addClass } = this.props
    return (
      <div className={ `logo ${addClass}` }>G</div>
    )
  }
}

export default Logo
