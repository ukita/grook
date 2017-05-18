import React, { Component } from 'react'
import { connect } from 'react-redux'
import { login, signup, changeTab, SIGN_IN_TAB, SIGN_UP_TAB } from '../../ducks/auth'
import Logo from '../../components/Logo'
import LoginForm from '../../components/LoginForm'
import RegistrationForm from '../../components/RegistrationForm'
import './style.css'

class Auth extends Component {
  constructor(props) {
    super(props)
    this.handleTabClick           = this.handleTabClick.bind(this)
    this.handleLoginSubmit        = this.handleLoginSubmit.bind(this)
    this.handleRegistrationSubmit = this.handleRegistrationSubmit.bind(this)
  }

  handleTabClick(tab) {
    return () => this.props.changeTab(tab)
  }

  handleLoginSubmit(values) {
    return this.props.login(values)
  }

  handleRegistrationSubmit(values){
    return this.props.signup(values)
  }

  render() {
    const { activeTab } = this.props
    return (
      <div className="chat-auth">
        <div className="chat-auth__form">
          <Logo addClass="chat-auth__logo" />
          <ul className="c-tabs">
            <li><a href="#" className={`c-tabs__action ${activeTab === SIGN_IN_TAB && `is-active`}`} onClick={this.handleTabClick(SIGN_IN_TAB)}>Sign in</a></li>
            <li><a href="#" className={`c-tabs__action ${activeTab === SIGN_UP_TAB && `is-active`}`} onClick={this.handleTabClick(SIGN_UP_TAB)}>Sign up</a></li>
          </ul>
          {activeTab === SIGN_IN_TAB && <LoginForm onSubmit={this.handleLoginSubmit}/>}
          {activeTab === SIGN_UP_TAB && <RegistrationForm onSubmit={this.handleRegistrationSubmit}/>}
        </div>
      </div>
    )
  }
}

function mapStateToProps(state) {
  const { isAuthenticated, activeTab } = state.auth
  
  return {
    isAuthenticated,
    activeTab
  }
}

export default connect(mapStateToProps, { login, signup, changeTab })(Auth)
