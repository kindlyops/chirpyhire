import React from 'react'

import CandidatesMenu from './candidatesMenu'
import CandidatesTable from './candidatesTable'
import Pagination from 'react-js-pagination'

class CandidatesListContainer extends React.Component {
  empty() {
    return (
      <div className='empty-candidates'>
        <h3 className='text-muted'>No caregivers found...</h3>
        <blockquote className='blockquote'>
          <p className='mb-0'>If you can dream it</p>
          <p className='mb-0'>you can do it</p>
          <footer className='mt-3 blockquote-footer'>Walt Disney</footer>
        </blockquote>
      </div>
    )
  }

  table() {
    return (<div>
      <CandidatesTable {...this.props} />
      <nav className='CandidatesListPagination'>
      <Pagination
        itemsCountPerPage={25}
        totalItemsCount={this.props.total_count}
        pageRangeDisplayed={5}
        activePage={this.props.current_page}
        pageCount={this.props.total_pages}
        itemClass={'page-item'}
        linkClass={'page-link'}
        nextPageText={'Next ›'}
        lastPageText={'Last »'}
        prevPageText={'‹ Prev'}
        firstPageText={'« First'}
        hideDisabled={true}
        onChange={this.props.onPageChange}
        />
      </nav>
    </div>)
  }

  render() {
    let body;
    if(this.props.candidates.length) {
      body = this.table()
    } else {
      body = this.empty()
    }

    return (
      <div className='CandidatesListContainer ch--sub-main'>
        <CandidatesMenu
          {...this.props}
          total_count={this.props.total_count}
          exportCSV={this.props.exportCSV}
        />
        {body}
      </div>
    )
  }
}

export default CandidatesListContainer
