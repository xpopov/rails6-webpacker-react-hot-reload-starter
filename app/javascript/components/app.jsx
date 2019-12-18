// Here goes wrappers over app such as Redux, providers, etc.
// No UI HMR updates here

// quote from manual:
// To make RHL more reliable and safe, please place hot below (ie somewhere in imported modules):

// react-dom
// redux store creation
// any data, you want to preserve between updates
// big libraries

import React from 'react'
import TopContainer from './top_container'

// Wrap with <Provider> or <Store>, etc. State of these components won't be changed on hot reload
const App = () => (
  <TopContainer />
)

export default App
