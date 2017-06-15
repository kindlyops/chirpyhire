const configuration = {
  form: {},
  certification: {
    icon: 'fa-graduation-cap',
    attribute: 'Certification',
    checked: false,
    options: [
      {
        label: 'PCA',
        value: 'pca',
        icon: 'fa-heart-o purple'
      },
      {
        label: 'CNA',
        value: 'cna',
        icon: 'fa-heart-o'
      },
      {
        label: 'HHA',
        value: 'hha',
        icon: 'fa-heart'
      },
      {
        label: 'RN, LPN, Other',
        value: 'other_certification',
        icon: 'fa-heartbeat'
      },
      {
        label: 'No Certification',
        value: 'no_certification',
        icon: 'fa-graduation-cap'
      }
    ]
  },
  location: {
    icon: 'fa-map-marker',
    attribute: 'Location',
    checked: false
  },
  starred: {
    icon: 'fa-star',
    attribute: 'Starred'
  },
  availability: {
    icon: 'fa-calendar-check-o',
    attribute: 'Availability',
    checked: false,
    options: [
      {
        label: 'Live-In',
        value: 'live_in',
        icon: 'fa-home'
      },
      {
        label: 'AM',
        value: 'hourly_am',
        icon: 'fa-sun-o'
      },
      {
        label: 'PM',
        value: 'hourly_pm',
        icon: 'fa-moon-o'
      },
      {
        label: 'Open',
        value: 'any_shift',
        icon: 'fa-flag-checkered'
      }
    ]
  },
  experience: {
    icon: 'fa-level-up',
    attribute: 'Experience',
    checked: false,
    options: [
      {
        icon: 'fa-battery-quarter',
        value: 'less_than_one',
        label: '0 - 1 years'
      },
      {
        icon: 'fa-battery-half',
        value: 'one_to_five',
        label: '1 - 5 years'
      },
      {
        icon: 'fa-battery-full',
        value: 'six_or_more',
        label: '6+ years'
      },
      {
        icon: 'fa-leaf',
        value: 'no_experience',
        label: 'No Experience'
      }
    ]
  },
  transportation: {
    icon: 'fa-road',
    attribute: 'Transportation',
    checked: false,
    options: [
      {
        icon: 'fa-car',
        value: 'personal_transportation', 
        label: 'Personal'
      },
      {
        icon: 'fa-bus',
        label: 'Public',
        value: 'public_transportation'
      },
      {
        icon: 'fa-thumbs-o-up',
        label: 'No Transportation',
        value: 'no_transportation'
      }
    ]
  }
}

export default configuration;
