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

  nearURL() {
    if(this.props.contact.live_in.query) {
      return `/candidates?availability[]=${encodeURIComponent(this.props.contact.availability.query)}&availability[]=${encodeURIComponent(this.props.contact.live_in.query)}&certification[]=${encodeURIComponent(this.props.contact.certification.query)}&experience[]=${encodeURIComponent(this.props.contact.experience.query)}&transportation[]=${encodeURIComponent(this.props.contact.transportation.query)}&zipcode=${encodeURIComponent(this.props.contact.zipcode.label)}`;
    } else {
      return `/candidates?availability[]=${encodeURIComponent(this.props.contact.availability.query)}&certification[]=${encodeURIComponent(this.props.contact.certification.query)}&experience[]=${encodeURIComponent(this.props.contact.experience.query)}&transportation[]=${encodeURIComponent(this.props.contact.transportation.query)}&zipcode=${encodeURIComponent(this.props.contact.zipcode.label)}`
    }
  }

  render() {
    return (
        <div className="profile-details">
          <div className="section-title profile-section-title">
            <span>Details</span>
          <div className="profile-main-filters">
            <Link data-toggle="tooltip" data-placement="left" className="profile-near-filter" to={this.nearURL()} title="View nearly identical caregivers.">
              <i className="fa fa-fw fa-bullseye mr-1"></i>
              Near
            </Link>
            <Link data-toggle="tooltip" data-placement="left" className="profile-broad-filter" to={`/candidates?certification[]=${encodeURIComponent(this.props.contact.certification.query)}&zipcode=${encodeURIComponent(this.props.contact.zipcode.label)}`} title="View broadly similar caregivers.">
              <i className="fa fa-fw fa-dot-circle-o mr-1"></i>
              Broad
            </Link>
          </div>
        </div>
        <p className="profile-detail-item">
          <span className="profile-detail-category">Location:</span>
          <span className="profile-detail-value">
            <Link data-toggle="tooltip" data-placement="left" to={`/candidates?zipcode=${encodeURIComponent(this.props.contact.zipcode.label)}`} data-original-title={`View caregivers in ${this.props.contact.zipcode.tooltip_label}.`}>
              <i className={`fa fa-fw mr-1 ${this.props.contact.zipcode.icon_class}`}></i>{this.props.contact.zipcode.label}
            </Link>
          </span>
        </p>
        <p className="profile-detail-item">
          <span className="profile-detail-category">Certification:</span>
          <span className="profile-detail-value">
            <Link data-toggle="tooltip" data-placement="left" to={`/candidates?certification[]=${encodeURIComponent(this.props.contact.certification.query)}`} data-original-title={`View ${this.props.contact.certification.tooltip_label}.`}>
              <i className={`fa fa-fw mr-1 ${this.props.contact.certification.icon_class}`}></i>
              {this.props.contact.certification.label}
            </Link>
          </span>
        </p>
        <p className="profile-detail-item">
          <span className="profile-detail-category">Availability:</span>
          <span className="profile-detail-value availability">
            <span className="profile-detail-subvalue">
              <Link data-toggle="tooltip" data-placement="left" to={`/candidates?availability[]=${encodeURIComponent(this.props.contact.availability.query)}`} data-original-title={`View caregivers ${this.props.contact.availability.tooltip_label}.`}>
                <i className={`fa fa-fw mr-1 ${this.props.contact.availability.icon_class}`}></i>
                {this.props.contact.availability.label}
              </Link>
            </span>
            {this.liveInSubvalue()}
          </span>
        </p>
        <p className="profile-detail-item">
          <span className="profile-detail-category">Experience:</span>
          <span className="profile-detail-value">
            <Link data-toggle="tooltip" data-placement="left" to={`/candidates?experience[]=${encodeURIComponent(this.props.contact.experience.query)}`} data-original-title={`View caregivers ${this.props.contact.experience.tooltip_label} experience.`}>
              <i className={`fa fa-fw mr-1 ${this.props.contact.experience.icon_class}`}></i>
              {this.props.contact.experience.label}
            </Link>
          </span>
        </p>
        <p className="profile-detail-item">
          <span className="profile-detail-category">Transportation:</span>
          <span className="profile-detail-value">
            <Link data-toggle="tooltip" data-placement="left" to={`/candidates?transportation[]=${encodeURIComponent(this.props.contact.transportation.query)}`} data-original-title={`View caregivers ${this.props.contact.transportation.tooltip_label} transportation.`}>
              <i className={`fa fa-fw mr-1 ${this.props.contact.transportation.icon_class}`}></i>
              {this.props.contact.transportation.label}
            </Link>
          </span>
        </p>
        <p className="profile-detail-item">
          <span className="profile-detail-category">CPR / 1st Aid:</span>
          <span className="profile-detail-value">
            <i className={`fa fa-fw mr-1 ${this.props.contact.cpr_first_aid.icon_class}`}></i>
            {this.props.contact.cpr_first_aid.label}
          </span>
        </p>
        <p className="profile-detail-item">
          <span className="profile-detail-category">Skin / TB Test:</span>
          <span className="profile-detail-value">
            <i className={`fa fa-fw mr-1 ${this.props.contact.skin_test.icon_class}`}></i>
            {this.props.contact.skin_test.label}
          </span>
        </p>
        <p className="profile-detail-item">
          <span className="profile-detail-category">Driver's License:</span>
          <span className="profile-detail-value">
            <i className={`fa fa-fw mr-1 ${this.props.contact.drivers_license.icon_class}`}></i>
            {this.props.contact.drivers_license.label}
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
