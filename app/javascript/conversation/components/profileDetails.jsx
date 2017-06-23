import React from 'react'
import { Link } from 'react-router-dom'

class ProfileDetails extends React.Component {

  liveInSubvalue() {
    if (this.props.contact.live_in.query) {
      return (
        <span className="profile-detail-subvalue">
          <Link to={`/candidates?availability[]=${encodeURIComponent(this.props.contact.live_in.query)}`} data-toggle='tooltip' data-placement='left' data-original-title={`View caregivers ${this.props.contact.live_in.tooltip_label}.`}>
            <i className={`fa fa-fw mr-1 ${this.props.contact.live_in.icon_class}`}></i>
            {this.props.contact.live_in.label}
          </Link>
        </span>
      )
    } else {
      return (
        <span className="profile-detail-subvalue">
          <span>
            <i className={`fa fa-fw mr-1 ${this.props.contact.live_in.icon_class}`}></i>
            {this.props.contact.live_in.label}
          </span>
        </span>
      )
    }
  }

  render() {
    return (
        <div className="profile-details">
          <div className="section-title profile-section-title">
            <span>Details</span>
          </div>
          <p className="profile-detail-item">
            <span className="profile-detail-category">Location:</span>
            <span className="profile-detail-value">
              <Link data-toggle="tooltip" data-placement="left" to={`/candidates?zipcode=${encodeURIComponent(this.props.contact.zipcode.label)}`} data-original-title={`View caregivers in ${this.props.contact.zipcode.tooltip_label}.`}>
                <i className={`fa fa-fw mr-1 ${this.props.contact.zipcode.icon_class}`}></i>{this.props.contact.zipcode.label}
              </Link>
            </span>
          </p>
      </div>
    )
  }

  componentWillUnmount() {
    let toolTips = $('.Inbox [data-toggle="tooltip"]');
    toolTips.tooltip('dispose');
  }

  componentDidUpdate() {
    let toolTips = $('.Inbox [data-toggle="tooltip"]');
    toolTips.attr('data-animation', false);
    toolTips.tooltip();
  }
}

export default ProfileDetails
