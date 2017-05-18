import React, { Component } from 'react'
import './style.css'

class Icon extends Component{
  render(){
    const { name, className } = this.props
    return (
      <svg className={`c-icon ${className}`}>
        <use xlinkHref={`#${name}`}></use>
      </svg>
    )
  }
}

export default Icon
