import React from 'react'

class LoadMoreConversations extends React.Component {
  render() {
    return(
      <div className='load-more-conversations'>
        <a href="#" role="button" onClick={this.props.onClick}>Load More Conversations</a>
      </div>
    )
  }
}

export default LoadMoreConversations
