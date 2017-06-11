import React from 'react'

import CandidateFilter from './candidateFilter'
import LocationCandidateFilter from './locationCandidateFilter'
import StarredCandidateFilter from './starredCandidateFilter'

class CandidateFilters extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      filters: {
        certification: {
          icon: 'fa-graduation-cap',
          attribute: 'Certification',
          options: [
            {
              label: 'PCA',
              query: 'pca',
              icon: 'fa-heart-o purple'
            },
            {
              label: 'CNA',
              query: 'cna',
              icon: 'fa-heart-o'
            },
            {
              label: 'HHA',
              query: 'hha',
              icon: 'fa-heart'
            },
            {
              label: 'RN, LPN, Other',
              query: 'other_certification',
              icon: 'fa-heartbeat'
            },
            {
              label: 'No Certification',
              query: 'no_certification',
              icon: 'fa-graduation-cap'
            }
          ]
        },
        location: {
          icon: 'fa-map-marker',
          attribute: 'Location'
        },
        starred: {
          icon: 'fa-star',
          attribute: 'Starred'
        },
        availability: {
          icon: 'fa-calendar-check-o',
          attribute: 'Availability',
          options: [
            {
              label: 'Live-In',
              query: 'live_in',
              icon: 'fa-home'
            },
            {
              label: 'AM',
              query: 'hourly_am',
              icon: 'fa-sun-o'
            },
            {
              label: 'PM',
              query: 'hourly_pm',
              icon: 'fa-moon-o'
            },
            {
              label: 'Open',
              query: 'any_shift',
              icon: 'fa-flag-checkered'
            }
          ]
        },
        experience: {
          icon: 'fa-level-up',
          attribute: 'Experience',
          options: [
            {
              icon: 'fa-battery-quarter',
              query: 'less_than_one',
              label: '0 - 1 years'
            },
            {
              icon: 'fa-battery-half',
              query: 'one_to_five',
              label: '1 - 5 years'
            },
            {
              icon: 'fa-battery-full',
              query: 'six_or_more',
              label: '6+ years'
            },
            {
              icon: 'fa-leaf',
              query: 'no_experience',
              label: 'No Experience'
            }
          ]
        },
        transportation: {
          icon: 'fa-road',
          attribute: 'Transportation',
          options: [
            {
              icon: 'fa-car',
              query: 'personal_transportation', 
              label: 'Personal'
            },
            {
              icon: 'fa-bus',
              label: 'Public',
              query: 'public_transportation'
            },
            {
              icon: 'fa-thumbs-o-up',
              label: 'No Transportation',
              query: 'no_transportation'
            }
          ]
        }
      }
    }
  }

  render() {
    return (
      <form className='CandidateFilters'>
        <div className='CandidateFiltersHeader'>
          <h3 className='small-caps'>Candidate Attributes</h3>
        </div>
        <LocationCandidateFilter {...this.state.filters.location} />
        <StarredCandidateFilter {...this.state.filters.starred} />
        <CandidateFilter {...this.state.filters.certification} />
        <CandidateFilter {...this.state.filters.availability} />
        <CandidateFilter {...this.state.filters.experience} />
        <CandidateFilter {...this.state.filters.transportation} />
      </form>
    )
  }
}

export default CandidateFilters
