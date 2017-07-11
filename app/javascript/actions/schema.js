import { schema } from 'normalizr';

const tagSchema = new schema.Entity('tags')

const followUpSchema = new schema.Entity('follow_ups', {
  tags: [tagSchema]
})

const questionSchema = new schema.Entity('questions', {
  follow_ups: [followUpSchema]
})

const greetingSchema = new schema.Entity('greetings')

const goalSchema = new schema.Entity('goals', {
  tags: [tagSchema]
})

export const botSchema = new schema.Entity('bots', {
  questions: [questionSchema],
  greeting: greetingSchema,
  goals: [goalSchema]
});

const campaignSchema = new schema.Entity('campaigns')
const inboxSchema    = new schema.Entity('inboxes')

export const arrayOfBotsSchema = [botSchema];
export const arrayOfInboxesSchema = [inboxSchema];
export const arrayOfCampaignsSchema = [campaignSchema];
