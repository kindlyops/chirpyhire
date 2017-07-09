import React from 'react'
import { Field, reduxForm } from 'redux-form'
import { connect } from 'react-redux'
import { withRouter } from 'react-router-dom'
import SubMain from '../../components/subMain'
import BotGreeting from './components/botGreeting'

class Bot extends React.Component {
  render() {
    const { handleSubmit } = this.props
    return (
      <SubMain>
        <form className='Bot' onSubmit={ handleSubmit }>
          <div className='BotHeader'>
            <label htmlFor="name" className='sr-only'>Bot Name</label>
            <Field className='BotName mb-3' name="name" component="input" type="text" />
          </div>
          <BotGreeting {...this.props} />
          <div>
            <label htmlFor="lastName">Last Name</label>
            <Field name="lastName" component="input" type="text" />
          </div>
          <div>
            <label htmlFor="email">Email</label>
            <Field name="email" component="input" type="email" />
          </div>
          <button type="submit">Submit</button>
        </form>
      </SubMain>
    )
  }
}

Bot = reduxForm({
  form: 'bot',
  enableReinitialize: true
})(Bot)

const mapStateToProps = (state, { match: { params } }) => {
  const {
    entities: { bots }
  } = state

  const bot = bots.byId[params.id] || {};
  
  return { initialValues: bot }
}

export default withRouter(connect(mapStateToProps, {})(Bot))
