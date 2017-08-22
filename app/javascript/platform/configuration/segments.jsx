const allSegment = {
        id: 'all',
        name: 'All',
        icon: 'fa-users',
        form: {}
      };

const newSegment = {
        id: 'new',
        name: 'New',
        icon: 'fa-user',
        form: {
          predicates: [
            { type: 'date', attribute: 'created_at', value: 1, comparison: 'lt' }
          ]
        }
      };

const activeSegment = {
        id: 'active',
        name: 'Active',
        icon: 'fa-bolt',
        form: {
          predicates: [
            { type: 'date', attribute: 'last_reply_at', value: 7, comparison: 'lt' }
          ]
        }
      };

const slippingAwaySegment = {
        id: 'slipping_away',
        name: 'Slipping Away',
        icon: 'fa-exclamation-triangle',
        form: {
          predicates: [
            { type: 'date', attribute: 'last_reply_at', value: 7, comparison: 'gt' },
            { type: 'date', attribute: 'last_reply_at', value: 30, comparison: 'lt' }
          ]
        }
      };

const passiveSegment = {
        id: 'passive',
        name: 'Passive',
        icon: 'fa-recycle',
        form: {
          predicates: [
            { type: 'date', attribute: 'last_reply_at', value: 30, comparison: 'gt' }
          ]
        }
      };

export default [allSegment, newSegment, activeSegment, slippingAwaySegment, passiveSegment];
