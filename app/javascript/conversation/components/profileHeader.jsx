import React from 'react'
import ProfileOutcome from './profileOutcome'
import _ from 'lodash';

class ProfileHeader extends React.Component {

  constructor(props) {
    super(props);

    this.state = {
      handle: props.contact.handle
    }

    this.onChange = this.onChange.bind(this);
    this.handleOnChange = _.debounce(this.handleOnChange, 400);
  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.contact.handle !== this.props.contact.handle) {
      this.setState({ handle: nextProps.contact.handle });
    }
  }

  onChange(event) {
    event.persist();
    this.setState({ handle: event.target.value });
    this.handleOnChange(event);
  }

  handleOnChange(event) {
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
              <input type="text" name="name" value={this.state.handle} onChange={this.onChange} />
            </div>
            <div className="profile-phone-number">{this.props.contact.phone_number}</div>
          </div>
        </div>
        <ProfileOutcome contact={this.props.contact} />
      </div>
    )
  }
}

export default ProfileHeader
