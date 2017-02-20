var Conversation = React.createClass({
  render: function() {
    return <div className='card'>
      <ConversationHeader />
      <ul className='list-group list-group-flush'>
        <Messages avatar={this.props.avatar}/>
        <Composer />
      </ul>
    </div>;
  }
});
