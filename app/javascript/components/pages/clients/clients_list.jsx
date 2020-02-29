import React, { Component, Fragment } from 'react'
import { Spinner } from 'react-bootstrap'
import { Query } from 'react-apollo'
import { Link } from 'react-router-dom'

import Table from '../../shared/table'
import DeleteClientForm from './delete_client'
import { listClients } from '../../../graphql/queries'

// import './orders.scss'

function ClientTable(props) {
  const columns = React.useMemo(
    () => [
      {
        Header: 'ID',
        accessor: 'id',
        Cell: v => <Link to={"/clients/" + v.cell.row.original.id}>{v.cell.value}</Link>
      },
      {
        Header: 'First Name',
        accessor: 'firstName',
      },
      {
        Header: 'Last Name',
        accessor: 'lastName',
      },
      {
        Header: 'Actions',
        Cell: v => <DeleteClientForm refetch={props.refetch} client={v.cell.row.original} />
      }
    ],
    []
  )

  const onFetchData = async (state, instance) => {
    const { page, pageSize, sorted, filtered } = state;
    console.log("fetching");
    // refetch()
    return data;
    // fetch code here
  };

  console.log(props.data.clients)
  const data = React.useMemo(() => props.data.clients, [])
  console.log(data)
  
  return <Table
    columns={columns}
    data={data}
    pageIndex={props.pageIndex}
    pageSize={props.pageSize}
    onSetPageSize={props.onSetPageSize}
    onSetPageIndex={props.onSetPageIndex}
  />;
}

class ClientsList extends Component {
  paging = { pageSize: 50, pageIndex: 0};

  handleRefetch(newPageSize, refetch) {
    this.paging.pageIndex = 0;
    this.paging.pageSize = newPageSize;
    refetch({
      page: this.paging.pageIndex,
      limit: this.paging.pageSize
    })
  }

  handleNewPage(newPageIndex, refetch) {
    this.paging.pageIndex = newPageIndex;
    refetch({
      page: this.paging.pageIndex,
      limit: this.paging.pageSize
    })
  }

  render() {
    return (
      <Query query={listClients} fetchPolicy="cache-and-network">
        {({ data, loading, error, refetch }) => {
          if (loading) return (
            <Fragment>
              <Spinner animation="border" role="status">
                <span className="sr-only">Loading...</span>
              </Spinner>
            </Fragment>
          );
          if (error) return <div>{error.message}</div>;
          console.log(data);
          return (
            <ClientTable data={data} 
              pageIndex={this.paging.pageIndex}
              pageSize={this.paging.pageSize}
              refetch={refetch}
              onFetchMore={() => this.handleFetchMore(newPageIndex, refetch)}
              onSetPageIndex={(newPageIndex) => this.handleNewPage(newPageIndex, refetch)}
              onSetPageSize={(newPageSize) => this.handleRefetch(newPageSize, refetch)}
            />
          );
        }}
      </Query>
    );
  }
}

 export default ClientsList