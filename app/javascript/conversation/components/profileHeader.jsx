import React from 'react'
import ProfileStage from './profileStage'
import ProfileSource from './profileSource'
import _ from 'lodash';

class ProfileHeader extends React.Component {

  constructor(props) {
    super(props);

    this.state = {
      handle: props.contact.handle,
      source: props.contact.source
    }

    this.onNameChange = this.onNameChange.bind(this);
    this.onSourceChange = this.onSourceChange.bind(this);
    this.handleOnNameChange = _.debounce(this.handleOnNameChange, 500);
    this.handleOnSourceChange = _.debounce(this.handleOnSourceChange, 500);

  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.contact.handle !== this.props.contact.handle) {
      this.setState({ handle: nextProps.contact.handle });
    }

    if (nextProps.contact.source !== this.props.contact.source) {
      this.setState({ source: nextProps.contact.source });
    }
  }

  onSourceChange(event) {
    event.persist();
    this.setState({ source: event.target.value });
    this.handleOnSourceChange(event);
  }

  onNameChange(event) {
    event.persist();
    this.setState({ handle: event.target.value });
    this.handleOnNameChange(event);
  }

  handleOnSourceChange(event) {
    this.props.onSourceChange(event);
  }

  handleOnNameChange(event) {
    this.props.onNameChange(event);
  }

  render() {
    return (
      <div className="profile-header">
        <div className='profile-header--inner'>
          <div className="profile-image">
            <div className={`author_image thumb_64 ${this.props.contact.hero_pattern_classes}`}></div>
          </div>
          <div className="profile-header-details">
            <div className="profile-handle">
              <input type="text" name="name" value={this.state.handle} onChange={this.onNameChange} />
            </div>
            <div className="profile-phone-number">{this.props.contact.phone_number}</div>
          </div>
        </div>
        <ProfileStage contact={this.props.contact} />
        <ProfileSource onSourceChange={this.onSourceChange} source={this.state.source} />
      </div>
    )
  }
}

export default ProfileHeader
