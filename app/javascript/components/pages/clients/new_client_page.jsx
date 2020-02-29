import React, { Component, Fragment } from 'react'
import { Page, Card } from '@shopify/polaris'
import { Query } from 'react-apollo'
import { Spinner } from 'react-bootstrap'

import { client } from '../../../graphql/queries'
import ClientForm from './client_form'

const NewClientPage = (props) => {
  const client = {
    price: 0.0,
    pageCount: 0
  }
  // pull from server later

  // <Query query={client} variables={{id: props.match.params.client_id}}>
  // {({ data, loading, error }) => {
  //   if (loading) return (
  //     <Fragment>
  //       <Spinner animation="border" role="status">
  //         <span className="sr-only">Loading...</span>
  //       </Spinner>
  //     </Fragment>
  //   );
  //   if (error) return <div>{error.message}</div>;
  //   console.log(data);
  return (
    <Page title={"Create Client"}>
      <Card sectioned>
        <ClientForm type="new" client={client} />
      </Card>
    </Page>
  );
  // }}
  // </Query>
}

export default NewClientPage
