import React, { Component, Fragment } from 'react'
import { Page, Card } from '@shopify/polaris'
import { Query } from 'react-apollo'
import { Spinner } from 'react-bootstrap'

import { client } from '../../../graphql/queries'
import ClientForm from './client_form'

const EditClientPage = (props) => (
  <Query query={client} variables={{id: props.match.params.client_id}}>
  {({ data, loading, error }) => {
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
      <Page title={"Client " + data.client.firstName }>
      <Card sectioned>
        <ClientForm type="edit" client={data.client} />
      </Card>
    </Page>
    );
  }}
  </Query>
)

export default EditClientPage
