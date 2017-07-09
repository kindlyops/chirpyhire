import React from 'react'
import { Field, reduxForm, initialize } from 'redux-form'
import { connect } from 'react-redux'
import { withRouter } from 'react-router-dom'

let BotForm = props => {
  const { handleSubmit } = props
  return (
    <form onSubmit={ handleSubmit }>
      <div>
        <label htmlFor="firstName">First Name</label>
        <Field name="firstName" component="input" type="text" />
      </div>
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
  )
}

BotForm = reduxForm({
  form: 'bot'
})(BotForm)

const mapStateToProps = (state, { match: { params } }) => {
  const {
    entities: { bots }
  } = state

  const bot = bots.byId[params.id]
  return { initialValues: bot }
}

export default withRouter(connect(mapStateToProps, {})(BotForm))
