import React, { Fragment } from 'react'
import { Query } from 'react-apollo'
import { Spinner } from 'react-bootstrap'
import { List, Page, Card } from '@shopify/polaris'

import { dashboardStatus } from '../../../graphql/queries'

const DashboardPage = () => {
  return (
    <Query query={dashboardStatus}>
    {({ data, loading, error }) => {
      if (loading) return (
        <Fragment>
          <Spinner animation="border" role="status">
            <span className="sr-only">Loading...</span>
          </Spinner>
        </Fragment>
      );
      if (error) return <div>{error.message}</div>;
      const dashboardStatus = data.dashboardStatus;
      console.log(dashboardStatus);
      return (
        <div className="dashboard-card">
          <Page title="Dashboard">
            <Card sectioned title="Orders">
              <Card.Section title="Processing">
                <Card.Subsection>
                  {dashboardStatus.processing}
                </Card.Subsection>
              </Card.Section>
              <Card.Section title="Shipped">
                <Card.Subsection>
                  {dashboardStatus.shipped}
                </Card.Subsection>
              </Card.Section>
              <Card.Section title="Failed">
                <Card.Subsection>
                  {dashboardStatus.failed}
                </Card.Subsection>
              </Card.Section>
              <Card.Section title="Cancelled">
                <Card.Subsection>
                  {dashboardStatus.cancelled}
                </Card.Subsection>
              </Card.Section>
            </Card>
          </Page>
        </div>
      );
    }}
    </Query>
  );
}

export default DashboardPage
