import React from 'react'
import { NavLink } from 'react-router-dom'

class inboxLink extends React.Component {
  constructor(props) {
    super(props);

    this.onTeam = this.onTeam.bind(this);
  }

  inboxURL() {
    return `/inboxes/${this.id()}/conversations`;
  }

  id() {
    return this.props.id;
  }

  isOnTeam() {
    return !!R.find(this.onTeam, this.props.current_account.teams);
  }

  onTeam(team) {
    return team.id === this.id();
  }

  teamIcon() {
    if(this.props.url) {
      return (
        <img className='author_image no-repeat thumb_24' src={this.props.url}></img>
      );
    } else {
      return (
        <span className={`author_image thumb_24 ${this.props.hero_pattern_classes}`}>
        </span>
      );
    }
  }

  icon() {
    if(this.isOnTeam()) {
      return <i className={'fa-user fa ml-2'}></i>;
    } else {
      return '';
    }
  }

  render() {
    return (
      <NavLink to={this.inboxURL()} role="button" className='InboxLink' tabIndex={0}>
        {this.teamIcon()}
        {this.props.name}
        {this.icon()}
      </NavLink>
    )
  }
}

export default inboxLink
