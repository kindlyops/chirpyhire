var Composer = React.createClass({
  render: function() {
    return <li className='list-group-item write-message'>
      <form>
        <div className='form-group'>
          <textarea className='form-control' autoFocus='true' rows='1' placeholder='Type a message'></textarea>
          <button className='btn btn-primary' type='submit'>
            <span>Message</span>
            <i className='fa fa-paper-plane white ml-2'></i>
          </button>
        </div>
      </form>
    </li>;
  }
});
