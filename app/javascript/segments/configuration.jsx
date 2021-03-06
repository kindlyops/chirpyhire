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
        id: 'slipping-away',
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

class Configuration {
  constructor() {
    this.all = allSegment;
    this.new = newSegment;
    this.active = activeSegment;
    this.slippingAway = slippingAwaySegment;
    this.passive = passiveSegment;
    this.loaded = false;
  }

  load() {
    if (this.loaded) {
      return new Promise();
    } else {
      return $.get('/contact_stages').then(stages => {
        let hired = _.find(stages, { name: 'Hired' });
        let not_now = _.find(stages, { name: 'Not Now' });

        if (hired) {
          this.slippingAway.form.predicates.push(
            this.potentialPredicate(hired)
          );
        }

        if (not_now) {
          this.slippingAway.form.predicates.push(
            this.potentialPredicate(not_now)
          );
        }

        this.loaded = true;
      });
    }
  }

  potentialPredicate(stage) {
    return {
      type: 'select', attribute: 'contact_stage_id', 
      value: stage.id, comparison: 'not_eq'
    }
  }

  segments() {
    return this.load().then(() =>
      [this.all, this.new, this.active, this.slippingAway, this.passive]
    );
  }
}

export default Configuration;
