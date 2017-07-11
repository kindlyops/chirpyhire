import React from 'react'

class RestartNotificationBar extends React.Component {

  constructor(props) {
    super(props);

    this.state = {
      active: false
    }

    this.reloadApp = this.reloadApp.bind(this);
  }

  reloadApp() {
    window.location.reload(true);
  }

  componentWillReceiveProps(nextProps) {
    let versionExists = !!this.props.client_version;
    let differentVersion = this.props.client_version !== nextProps.client_version;

    if(versionExists && differentVersion) {
      this.setState({ active: true });
    }
  }

  render() {
    if (this.state.active) {
      return(
        <div className='ch--notification'>
          <i className='fa fa-flag mr-2'></i>
          <span>
            Want the latest version of ChirpyHire?
            Just <a onClick={this.reloadApp} tabIndex={0} role="button">restart ChirpyHire</a> to upgrade.
          </span>
        </div>
      );
    } else {
      return null;
    }
  }
}

export default RestartNotificationBar
