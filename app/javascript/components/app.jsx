// Here goes wrappers over app such as Redux, providers, etc.
// No UI HMR updates here

// quote from manual:
// To make RHL more reliable and safe, please place hot below (ie somewhere in imported modules):

// react-dom
// redux store creation
// any data, you want to preserve between updates
// big libraries

import React from 'react'
// import { Provider, TitleBar } from '@shopify/app-bridge-react'
// import { AppProvider, Page } from '@shopify/polaris'

import { ApolloClient } from 'apollo-client'
import { InMemoryCache } from 'apollo-cache-inmemory'
import { createHttpLink } from 'apollo-link-http'
import { ApolloProvider } from 'react-apollo'
import { BrowserRouter } from 'react-router-dom'

import ShopifyAppBridge from './shopify_app_bridge'
import '../graphql/queries'

import 'react-hot-loader'
import Navigation from './layout/navigation'

const link = new createHttpLink({
  uri: '/graphql',
  credentials: 'include',
})

const client = new ApolloClient({
  fetchOptions: {
    credentials: 'include'
  },
  link: link,
  cache: new InMemoryCache()
})

const config = require("json-loader!yaml-loader!../../../config/shopify_api.yml")
const currentConfig = config[process.env.NODE_ENV]
console.log(currentConfig)
// const config = {apiKey: '12345', shopOrigin: shopOrigin};

const App = () => (
  <BrowserRouter>
    <ShopifyAppBridge config={currentConfig}>
        <ApolloProvider client={client}>
          <Navigation />
        </ApolloProvider>
    </ShopifyAppBridge>
  </BrowserRouter>
)

export default App
