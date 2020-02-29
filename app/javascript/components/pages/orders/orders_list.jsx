import React, { Component, Fragment } from 'react';
import { Spinner } from 'react-bootstrap'
import { Query } from 'react-apollo';
import { Button, Tooltip } from '@shopify/polaris';
import ReactTable, { useTable, usePagination } from 'react-table'
import { listOrders } from '../../../graphql/queries'

import ResendOrder from './resend_order'
import './orders.scss'

// Create a default prop getter
const defaultPropGetter = () => ({})

function Table({
  columns,
  data,
  pageIndex,
  pageSize,
  onSetPageSize,
  onSetPageIndex,
  onFetchData = defaultPropGetter,
  getHeaderProps = defaultPropGetter,
  getColumnProps = defaultPropGetter,
  getRowProps = defaultPropGetter,
  getCellProps = defaultPropGetter,
}) {
  const {
    getTableProps,
    getTableBodyProps,
    headerGroups,
    rows,
    prepareRow,
    setPageSize,
    // state: { pageIndex, pageSize },
  } = useTable({
    columns,
    data,
    initialState: { pageIndex: 0 },
    onFetchData: onFetchData
  }, usePagination)

  return (
    <>
      <table {...getTableProps()} className="table table-hover table-striped">
        <thead className="thead-dark">
          {headerGroups.map(headerGroup => (
            <tr {...headerGroup.getHeaderGroupProps()}>
              {headerGroup.headers.map(column => (
                <th
                  // Return an array of prop objects and react-table will merge them appropriately
                  {...column.getHeaderProps([
                    {
                      className: column.className,
                      style: column.style,
                    },
                    getColumnProps(column),
                    getHeaderProps(column),
                  ])}
                >
                  {column.render('Header')}
                </th>
              ))}
            </tr>
          ))}
        </thead>
        <tbody {...getTableBodyProps()}>
          {rows.map((row, i) => {
            prepareRow(row)
            return (
              // Merge user row props in
              <tr {...row.getRowProps(getRowProps(row))}>
                {row.cells.map(cell => {
                  return (
                    <td
                      // Return an array of prop objects and react-table will merge them appropriately
                      {...cell.getCellProps([
                        {
                          className: cell.column.className,
                          style: cell.column.style,
                        },
                        getColumnProps(cell.column),
                        getCellProps(cell),
                      ])}
                    >
                      {cell.render('Cell')}
                    </td>
                  )
                })}
              </tr>
            )
          })}
        </tbody>
      </table>
      <div className="pagination">
        <button onClick={() => onSetPageIndex(pageIndex - 1)} disabled={pageIndex == 0}>
          {'<'}
        </button>{' '}
        <button onClick={() => onSetPageIndex(pageIndex + 1)} disabled={rows.length < pageSize}>
          {'>'}
        </button>{' '}
        <span>
          Page{' '}
          <strong>
            {pageIndex + 1}
          </strong>{' '}
        </span>
        <select
          value={pageSize}
          onChange={e => {
            setPageSize(Number(e.target.value))
            onSetPageSize(Number(e.target.value))
          }}
        >
          {[10, 30, 50, 100].map(pageSize => (
            <option key={pageSize} value={pageSize}>
              Show {pageSize}
            </option>
          ))}
        </select>
      </div>
    </>
  )
}


function OrderTable(props) {
  const columns = React.useMemo(
    () => [
      {
        Header: 'Order #',
        accessor: 'orderNumber',
      },
      {
        Header: 'Email',
        accessor: 'email',
      },
      {
        Header: 'Date',
        accessor: 'createdAt',
      },
      {
        Header: 'Amount',
        accessor: 'totalPrice',
        Cell: v => <span>{"$" + v.cell.value}</span>
      },
      {
        Header: 'Status',
        accessor: 'status',
      },
      {
        Header: 'Actions',
        Cell: v => (
          null
        )
      },
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

  console.log(props.data.orders)
  // [
  //   {orderNumber: "#1", createdAt: "2020", totalPrice: "$200"},
  //   {orderNumber: "#2", createdAt: "2020", totalPrice: "$250"}
  // ]
  const data = React.useMemo(() => props.data.orders, [])
  console.log(data)
  
  return <Table
    columns={columns}
    data={data}
    pageIndex={props.pageIndex}
    pageSize={props.pageSize}
    refetch={props.refetch}
    onSetPageSize={props.onSetPageSize}
    onSetPageIndex={props.onSetPageIndex}
  />;
}

class OrdersList extends Component {
  paging = { pageSize: 50, pageIndex: 0};

  handleRefetch(newPageSize, refetch) {
    this.paging.pageIndex = 0;
    this.paging.pageSize = newPageSize;
    refetch({
      page: this.paging.pageIndex,
      limit: this.paging.pageSize,
      selection: this.props.selection
    })
  }

  handleNewPage(newPageIndex, refetch) {
    this.paging.pageIndex = newPageIndex;
    refetch({
      page: this.paging.pageIndex,
      limit: this.paging.pageSize,
      selection: this.props.selection
    })
  }

  render() {
    return (
      <>
      <Query query={listOrders} variables={{selection: this.props.selection}}>
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
            <OrderTable data={data} 
              pageIndex={this.paging.pageIndex}
              pageSize={this.paging.pageSize}
              refetch={refetch}
              onFetchMore={() => this.handleFetchMore(newPageIndex, refetch)}
              onSetPageIndex={(newPageIndex) => this.handleNewPage(newPageIndex, refetch)}
              onSetPageSize={(newPageSize) => this.handleRefetch(newPageSize, refetch)}
            />
          );
        //   <Card>
        //   <p>stuff here</p>
        // </Card>
    }}
      </Query>
      </>
    );
  }
}

 export default OrdersList