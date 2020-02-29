import React from 'react'
import { Page, Card } from '@shopify/polaris'

import ClientsList from './clients_list'

const ClientsPage = () => (
  <>
    <Page title="Clients" style={{minWidth: '500px'}}>
      <Card sectioned actions={[{content: 'Add New Client...', url: '/clients/new'}]}>
        <ClientsList />
      </Card>
    </Page>
  </>
)

export default ClientsPage
