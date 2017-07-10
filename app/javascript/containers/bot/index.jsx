import React from 'react'
import { Field, FieldArray, reduxForm, getFormValues } from 'redux-form'
import { connect } from 'react-redux'
import { withRouter } from 'react-router-dom'
import SubMain from '../../components/subMain'
import BotGreeting from './components/botGreeting'
import BotQuestion from './components/botQuestion'
import BotGoal from './components/botGoal'

const renderBotQuestions = ({ formValues, fields, meta: { error, submitFailed } }) => (
  <div>
    {fields.map((question, index) => (<BotQuestion formValues={formValues} question={question} index={index} key={index} />))}
  </div>
)

const renderBotGoals = ({ formValues, fields, meta: { error, submitFailed } }) => (
  <div>
    {fields.map((goal, index) => (<BotGoal formValues={formValues} goal={goal} index={index} key={index} />))}
  </div>
)

class Bot extends React.Component {
  render() {
    const { handleSubmit } = this.props
    return (
      <SubMain>
        <form className='Bot' onSubmit={ handleSubmit }>
          <div className='BotHeader'>
            <label htmlFor="bot.name" className='sr-only'>Bot Name</label>
            <Field className='BotName mb-3' name="bot.name" component="input" type="text" />
          </div>
          <BotGreeting {...this.props} />
          <FieldArray name="bot.questions_attributes" props={this.props} component={renderBotQuestions} />
          <FieldArray name="bot.goals_attributes" props={this.props} component={renderBotGoals} />
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
    entities: { bots, greetings, questions, goals, follow_ups, tags }
  } = state

  const defaultBot = {
    greeting_attributes: {},
    questions_attributes: [],
    goals_attributes: []
  };

  const bot = bots.byId[params.id] || defaultBot;
  if (bot.greeting) {
    bot.greeting_attributes = greetings.byId[bot.greeting] || {};

    const toFollowUp = (id) => {
      const follow_up = follow_ups.byId[id];
      const tags_attributes = follow_up.tags && follow_up.tags.map(uid => tags.byId[uid]) || [];
      follow_up.tags_attributes = tags_attributes;
      delete follow_up.tags;
      return follow_up;
    }

    const toQuestion = (id) => {
      const question = questions.byId[id];
      const follow_ups_attributes = question.follow_ups && question.follow_ups.map(toFollowUp) || [];
      question.follow_ups_attributes = follow_ups_attributes;
      delete question.follow_ups;
      return question;
    }

    const questions_attributes = bot.questions && bot.questions.map(toQuestion) || [];
    bot.questions_attributes = questions_attributes;
    const goals_attributes = bot.goals && bot.goals.map(id => goals.byId[id]) || []; 
    bot.goals_attributes = goals_attributes;
    delete bot.goals;
    delete bot.greeting;
    delete bot.questions;
  }

  const form = { bot: bot };
  return { initialValues: form, formValues: getFormValues('bot')(state) }
}

export default withRouter(connect(mapStateToProps, {})(Bot))
