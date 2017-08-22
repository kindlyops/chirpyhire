const configuration = {
  location: {
    icon: 'fa-map-marker',
    attribute: 'Location',
    checked: false
  },
  tags: {
    attribute: 'Tag',
    checked: false,
    icon: 'fa-tag',
    options: [],
    name: 'tags',
    filter: 'matches_all_tags'
  },
  name: {
    attribute: 'Name',
    checked: false,
    icon: 'fa-users'
  },
  messages: {
    attribute: 'Messages',
    checked: false,
    icon: 'fa-comments-o'
  },
  contact_stage: {
    attribute: 'Stage',
    name: 'contact_stage',
    checked: false,
    icon: 'fa-cube',
    options: [],
    filter: 'contact_stage_id_in'
  },
  campaigns: {
    attribute: 'Campaigns',
    name: 'campaigns',
    checked: false,
    icon: 'fa-paper-plane-o',
    options: [],
    filter: 'matches_all_manual_messages'
  },
  created_at: {
    attribute: 'First Seen',
    name: 'created_at',
    checked: false,
    icon: 'fa-calendar'
  },
  last_reply_at: {
    attribute: 'Last Seen',
    name: 'last_reply_at',
    checked: false,
    icon: 'fa-calendar'
  }
}

export default configuration;
