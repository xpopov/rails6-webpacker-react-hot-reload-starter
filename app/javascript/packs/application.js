/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

console.log('Hello World from Webpacker')

// for development HMR
import './styles.scss';

import React from 'react'
import ReactDOM from 'react-dom'
import App from '../components/app'

import 'bootstrap/dist/css/bootstrap.min.css'
// UMD?
// import 'bootstrap/dist/js/bootstrap.bundle'
import 'jquery/dist/jquery.slim'
// import 'bootstrap'
import '@shopify/polaris/styles.css'

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <App />,
    document.querySelector('#root')
  )
})

document.addEventListener("turbolinks:load", () => {
  // Turbolinks.clearCache();
  console.log("turbolinks: loading");

  const element = document.getElementById('root');
  // // if (element)
  //   // element.parentNode.removeChild(element);
  // while (element.firstChild) {
  //   element.removeChild(element.firstChild);
  // }
  // ReactDOM.unmountComponentAtNode(element);

  if (!ReactDOM.findDOMNode(element)) {
    ReactDOM.render(
      <App />,
      element
    )
  }
});

// require("shopify_app")
