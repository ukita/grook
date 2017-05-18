import React, { Component } from 'react'
import { connect } from 'react-redux'
import { closeDrawer } from '../../ducks/drawer'
import Icon from '../../components/Icon'
import './style.css'

class DrawerManager extends Component {
  render() {
    const { isOpen, component, title } = this.props
    
    if(isOpen && component) {
      return (
        <div className="c-drawer is-open">
          <span className="c-drawer__close" onClick={this.props.closeDrawer}><Icon name="close"/></span>
          <div className="c-drawer__header">{ title || "" }</div>
          <div className="c-drawer__content">
            { component }
          </div>
        </div>
      )
    }

    return <div className="c-drawer"/>
  }
}

function mapStateToProps(state) {
  const { isOpen, title, component } = state.drawer
  
  return {
    isOpen,
    title,
    component
  }
}

export default connect(mapStateToProps, { closeDrawer })(DrawerManager)
