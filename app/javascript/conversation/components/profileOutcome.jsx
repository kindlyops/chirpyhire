import React from 'react'
import Select from 'react-select'

class ProfileOutcome extends React.Component {
  constructor(props) {
    super(props)

    this.options = this.options.bind(this);
    this.onChange = this.onChange.bind(this);
    this.id = this.id.bind(this);
  }

  onChange({ value, label }) {
    const form = $(`form#${this.id()}`);
    const data = { 
      _method: 'put', contact: { outcome: value }
    }
    const config = {
      url: form.attr('action'),
      data: data,
      type: 'POST',
      method: 'POST',
      dataType: 'text'
    }
    $.ajax(config);
  }

  options() {
    return this.props.contact.outcomes.map(outcome => ({ value: outcome, label: outcome }));
  }

  id() {
    return `edit_contact_${this.props.contact.id}`;
  }

  render() {
    return (
        <form className='edit_contact' id={this.id()} method="post" action={`/contacts/${this.props.contact.id}`}>
          <Select
            name="contact[outcome]"
            className='mt-3'
            options={this.options()}
            value={this.props.contact.outcome}
            onChange={this.onChange}
            clearable={false}
          />
        </form>
    )
  }
}

ProfileOutcome.defaultProps = {
  contact: {
    outcomes: [],
    outcome: ''
  }
}

export default ProfileOutcome