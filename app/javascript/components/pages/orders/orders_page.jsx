import React, { useCallback, useState } from 'react'
import { Card, Page, Tabs } from '@shopify/polaris'

import OrdersList from './orders_list'

const OrdersPage = props => {
  const [selected, setSelected] = useState(0);

  const handleTabChange = useCallback(
    (selectedTabIndex) => setSelected(selectedTabIndex),
    [],
  );
  
  const tabs = [
    {
      id: 'all',
      content: 'All',
      accessibilityLabel: 'All Orders',
      panelID: 'all-content',
    },
    {
      id: 'pending',
      content: 'Pending',
      panelID: 'pending-content',
    },
    {
      id: 'processing',
      content: 'Processing',
      panelID: 'processing-content',
    },
    {
      id: 'shipped',
      content: 'Shipped',
      panelID: 'shipped-content',
    },
    {
      id: 'cancelled',
      content: 'Cancelled',
      panelID: 'cancelled-content',
    },
    {
      id: 'failed',
      content: 'Failed',
      panelID: 'failed-content',
    },
  ];
  
  return (
    <>
      <Page title="Orders" style={{minWidth: '500px'}}>
        <Card>
          <Tabs tabs={tabs} selected={selected} onSelect={handleTabChange}>
            <OrdersList selection={ tabs[selected].id } />
          </Tabs>
        </Card>
      </Page>
    </>
  );
}

export default OrdersPage
