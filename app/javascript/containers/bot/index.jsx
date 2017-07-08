import React from 'react'

import BotForm from '../../components/botForm'
import SubMain from '../../components/subMain'

class Bot extends React.Component {
  render() {
    return (
      <SubMain>
        <BotForm onSubmit={this.props.onSubmit} />
      </SubMain>
    )
  }
}

export default Bot
