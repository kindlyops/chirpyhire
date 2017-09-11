import React from 'react'
import Select from 'react-select'

class ProfileOutcome extends React.Component {
  constructor(props) {
    super(props)

    this.options = this.options.bind(this);
    this.onChange = this.onChange.bind(this);
  }

  onChange({ value, label }) {
    const form = $(`form#${this.id()}`);
    const data = { 
      _method: 'put', contact: { contact_stage_id: value }
    }
    const config = {
      url: form.attr('action'),
      data: data,
      type: 'POST',
      method: 'POST',
      dataType: 'text'
    }
    $.ajax(config).then(() => {
      let properties = { 
        name: label, id: value, contact_id: this.props.contact.id 
      };
      
      heap.track('Set Candidate Stage', properties);
    });
  }

  options() {
    return this.props.contact.contact_stages.map(stage => ({ value: stage.id, label: stage.name }));
  }

  render() {
    return (
      <div className='form-group'>
        <Select
          name="contact[contact_stage_id]"
          className='mt-3'
          options={this.options()}
          value={this.props.contact.contact_stage_id}
          onChange={this.onChange}
          clearable={false}
        />
      </div>
    )
  }
}

ProfileOutcome.defaultProps = {
  contact: {
    contact_stages: [],
    contact_stage_id: ''
  }
}

export default ProfileOutcome
