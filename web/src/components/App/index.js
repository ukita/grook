import React, { Component } from 'react'
import './style.css'

class App extends Component {
  render() {
    const { children } = this.props
    return (
      <main className="chat">
        { children }
      </main>
    )
  }
}

export default App
