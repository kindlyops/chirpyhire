import React from 'react'
import { Field, reduxForm } from 'redux-form'
import { connect } from 'react-redux'
import { load as loadBot } from '../reducers/bot'

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

// BotForm = connect(
//   state => ({
//     initialValues: state.bot.data // pull initial values from account reducer
//   }),
//   { load: loadBot } // bind account loading action creator
// )(BotForm)

export default BotForm
