import React from 'react'
import { Page, Card } from '@shopify/polaris'

import SettingsForm from './settings_form'

const SettingsPage = () => (
  <>
    <Page title="Settings">
      <Card sectioned>
        <SettingsForm />
      </Card>
    </Page>
  </>
)

export default SettingsPage
